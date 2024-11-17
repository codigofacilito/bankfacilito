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
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
