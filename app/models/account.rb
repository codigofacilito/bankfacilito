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

  def to_s
    "#{account_number} - #{user}"
  end
end
