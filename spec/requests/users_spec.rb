require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /register' do
    let(:valid_attributes) do
      {
        first_name: 'Juan',
        last_name: 'Perez',
        email: 'juan.perez@example.com',
        pin: '1234'
      }
    end

    context 'when the request is valid' do
      it 'creates a new user' do
        expect {
          post '/register', params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'creates an associated account with an initial balance of $1,000' do
        post '/register', params: valid_attributes
        user = User.last
        account = user.accounts.first
        expect(account).not_to be_nil
        expect(account.balance).to eq(1_000)
      end
    end

    context 'when the request is invalid' do
      it 'does not create a user without email' do
        invalid_attributes = valid_attributes.except(:email)
        expect {
          post '/register', params: invalid_attributes
        }.not_to change(User, :count)
      end
    end
  end

  describe 'POST /login' do
    let(:user) { create(:user, pin: '1234') }
    let(:account) { create(:account, user: user) }

    context 'with valid credentials' do
      it 'logs in successfully' do
        post '/login', params: { account_number: account.account_number, pin: '1234' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Inicio de sesión exitoso')
      end
    end

    context 'with invalid credentials' do
      it 'rejects login with incorrect PIN' do
        post '/login', params: { account_number: account.account_number, pin: '0000' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to eq('Número de cuenta o PIN incorrecto')
      end

      it 'rejects login with incorrect account number' do
        post '/login', params: { account_number: 'invalid', pin: '1234' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to eq('Número de cuenta o PIN incorrecto')
      end
    end
  end
end