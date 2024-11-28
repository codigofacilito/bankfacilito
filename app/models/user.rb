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
  has_one :account, -> { where(default: true) }, class_name: 'Account'
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
    accounts.create(default: true, balance: 1_000)
  end
end
