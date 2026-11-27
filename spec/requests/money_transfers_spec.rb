require 'rails_helper'

RSpec.describe 'Money transfers', type: :request do
  let(:user) { create(:user, pin: '1234') }
  let(:origin) { user.accounts.first }
  let(:recipient_account) { create(:account, user: nil, balance: 20) }
  let(:recipient) { Recipient.create!(user: user, account: recipient_account, name: 'Recipient') }
  let(:headers) { { 'Authorization' => 'Bearer ' + JsonWebToken.encode(user_id: user.id) } }

  it 'transfers a fractional amount through the transactions endpoint' do
    post "/api/v1/accounts/#{origin.id}/transactions",
      params: { recipient_id: recipient.id, amount: '10.50' }, headers: headers, as: :json

    expect(response).to have_http_status(:ok)
    expect(origin.reload.balance).to eq(BigDecimal('989.50'))
    expect(recipient_account.reload.balance).to eq(BigDecimal('30.50'))
    expect(origin.transactions.last.amount).to eq(BigDecimal('10.50'))
  end

  it 'rejects excess precision through the transactions endpoint' do
    post "/api/v1/accounts/#{origin.id}/transactions",
      params: { recipient_id: recipient.id, amount: '10.501' }, headers: headers, as: :json

    expect(response).to have_http_status(:unprocessable_entity)
    expect(origin.reload.balance).to eq(1000)
    expect(recipient_account.reload.balance).to eq(20)
    expect(Transaction.count).to eq(0)
  end

  it 'validates precision for service payments' do
    service = create(:service, account: recipient_account)
    post "/api/v1/accounts/#{origin.id}/pay_service",
      params: { service_id: service.id, amount: '10.501' }, headers: headers, as: :json

    expect(response).to have_http_status(:unprocessable_entity)
    expect(Transaction.count).to eq(0)

    post "/api/v1/accounts/#{origin.id}/pay_service",
      params: { service_id: service.id, amount: '10.50' }, headers: headers, as: :json

    expect(response).to have_http_status(:ok)
    expect(origin.reload.balance).to eq(BigDecimal('989.50'))
    expect(recipient_account.reload.balance).to eq(BigDecimal('30.50'))
  end
end
