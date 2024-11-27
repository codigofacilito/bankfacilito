# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  first_name        :string
#  last_name         :string
#  pin_digest        :string
#  biometric_enabled :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  email             :string
#
class User < ApplicationRecord
   has_many :accounts
   has_secure_password :pin, validations: false

   validates :first_name, presence: true
   validates :last_name, presence: true
   validates :email, presence: true, uniqueness: true
   validates :pin, presence: true, length: { is: 4 }, numericality: { only_integer: true }

   after_create :create_default_account

   validates :email, allow_blank: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

   def to_s
      "#{first_name} #{last_name}"
   end

   private

   def create_default_account
      accounts.create(
        account_number: generate_account_number,
        account_type: 0,
        balance: 1000,
        CLABE: generate_clabe
      )
   end

   def generate_clabe
      loop do
        clabe = SecureRandom.alphanumeric(18).upcase
        break clabe unless Account.exists?(CLABE: clabe)
      end
   end

   def generate_account_number
      loop do
        random_number = rand(10**9..10**10-1).to_s
        break random_number unless Account.exists?(account_number: random_number)
      end
   end
end
