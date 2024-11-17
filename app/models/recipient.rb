# == Schema Information
#
# Table name: recipients
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  name       :string
#  account_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Recipient < ApplicationRecord
  belongs_to :user
  belongs_to :account
end
