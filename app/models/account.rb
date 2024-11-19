# == Schema Information
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  account_number :string
#  account_type   :integer
#  balance        :integer
#  CLABE          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Account < ApplicationRecord
  belongs_to :user
  
  def transfer!(recipient, amount, description=nil)
    Transaction.transfer!(self, recipient, amount, description)
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
end
