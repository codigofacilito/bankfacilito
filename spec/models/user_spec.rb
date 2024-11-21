require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is not valid without email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with duplicated email' do
      create(:user, email: 'duplicado@example.com', pin: '1234')
      user = build(:user, email: 'duplicado@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'not valid without alphanumeric pin' do
      user = build(:user, pin: 'abcd')
      expect(user).not_to be_valid
      expect(user.errors[:pin]).to include('is not a number')
    end

    it 'not valid without 4 characters pin' do
      user = build(:user, pin: '123')
      expect(user).not_to be_valid
      expect(user.errors[:pin]).to include('is the wrong length (should be 4 characters)')
    end
  end

  describe 'callbacks' do
    it 'create an account after user creation' do
      user = create(:user, email:'test@example.com', pin: '1234')
      expect(user.accounts.count).to eq(1)
    end
  end
end