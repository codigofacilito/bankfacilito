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
require "test_helper"

class RecipientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
