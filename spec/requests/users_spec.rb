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

    let(:endpoint) { '/api/v1/register' }

    context 'when the request is valid' do
      it 'Create a new User' do
        expect {
          post endpoint, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'returns status code 201' do
        post endpoint, params: valid_attributes
        expect(response).to have_http_status(201)
      end

    end

  end

  describe 'POST /login' do
    let(:user) { create(:user, pin: '1234') }
    let(:account) { create(:account, user: user) }
    let(:endpoint) { '/api/v1/login' }
  
    context 'with valid credentials' do
      it 'logs in successfully' do
        post  endpoint, params: { account_number: account.account_number, pin: '1234' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Inicio de sesión exitoso')
      end
    end
  
    context 'with invalid credentials' do
      it 'rejects login with incorrect PIN' do
        post  endpoint, params: { account_number: account.account_number, pin: '0000' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to eq('Número de cuenta o PIN incorrecto')
      end
  
      it 'rejects login with incorrect account number' do
        post  endpoint, params: { account_number: 'invalid', pin: '1234' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to eq('Número de cuenta o PIN incorrecto')
      end
    end
  end
  
end