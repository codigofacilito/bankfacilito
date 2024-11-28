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
FactoryBot.define do
  factory :account do
    user
    account_number { "1234567890" }
    balance        { 1_000 }
    clabe          { "123456789012345678" }
  end
end
