# == Schema Information
#
# Table name: services
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  account_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Service < ApplicationRecord
  belongs_to :account
  validates :name, presence: true
end
