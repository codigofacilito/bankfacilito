# == Schema Information
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  account_number :string
#  balance        :integer          default(0)
#  clabe          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  default        :boolean          default(FALSE)
#  account_type   :integer          default("user"), not null
#
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
