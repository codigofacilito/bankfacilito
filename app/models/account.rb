# == Schema Information
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  account_number :string
#  balance        :integer          default(0)
#  clabe          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  default        :boolean          default(FALSE)
#
class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  after_create :set_default, if: :default?
  
  before_validation :generate_clabe
  before_validation :generate_account_number
  
  validates :clabe, presence: true, uniqueness: true
  validates :account_number, presence: true, uniqueness: true

  def transfer!(recipient_account_number, amount, description = nil)
    recipient_account = Account.find_by(account_number: recipient_account_number)
    TransactionService.new.transfer!(self, recipient_account_number, amount, description)
  end
  
  def default?
    default
  end

  def withdraw!(amount)
    self.balance -= amount
    save!
  end

  def deposit!(amount)
    self.balance += amount
    save!
  end

  def to_s
    "#{account_number} - #{user}"
  end

  private

  def set_default
    return false unless default?
    user.accounts.where.not(id: id).update_all(default: false)
  end

  def generate_clabe
    self.clabe = loop do
      random_clabe = rand(10**17..10**18 - 1).to_s
      break random_clabe unless Account.exists?(clabe: random_clabe)
    end
  end

  def generate_account_number
    self.account_number = rand(10**9..10**10 - 1).to_s
  end
end
