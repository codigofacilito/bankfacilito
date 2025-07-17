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
          post endpoint, params: valid_attributes, headers: { 'Content-Type': 'application/json' }, as: :json
        }.to change(User, :count).by(1)
      end

      it 'returns status code 201' do
        post endpoint, params: valid_attributes, headers: { 'Content-Type': 'application/json' }, as: :json
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
        post endpoint, params: { account_number: account.account_number, pin: '1234' }, headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Inicio de sesión exitoso')
      end
    end
  
    context 'with invalid credentials' do
      it 'rejects login with incorrect PIN' do
        post  endpoint, params: { account_number: account.account_number, pin: '0000' }, headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to eq('Número de cuenta o PIN incorrecto')
      end
  
      it 'rejects login with incorrect account number' do
        post  endpoint, params: { account_number: 'invalid', pin: '1234' }, headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to eq('Número de cuenta o PIN incorrecto')
      end
    end
  end

  describe 'PUT /update' do
    let(:user) { create(:user, pin: '1234') }
    let(:account) { create(:account, user: user) }

    context 'when the request is valid' do
      it 'updates the user' do
        post '/api/v1/login', params: { account_number: account.account_number, pin: '1234' }, headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:ok)
        
        response_body = JSON.parse(response.body)
        user_id = response_body['user']['id']
        token = response_body['token']
        
        put "/api/v1/users/#{user_id}", params: { first_name: 'Cody', last_name: 'Facilito', email: 'ayuda@codigofacilito.com' }, headers: { 'Authorization' => "Bearer #{token}", 'Content-Type': 'application/json' }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user']['first_name']).to eq('Cody')
        expect(JSON.parse(response.body)['user']['last_name']).to eq('Facilito')
      end
    end
  end
end