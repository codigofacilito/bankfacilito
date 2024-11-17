# == Schema Information
#
# Table name: transactions
#
#  id                   :integer          not null, primary key
#  account_id           :integer          not null
#  transaction_type     :integer
#  amount               :decimal(, )
#  recipient_account_id :integer
#  description          :text
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Transaction < ApplicationRecord
  belongs_to :account
end
