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
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
