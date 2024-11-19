FactoryBot.define do
  factory :account do
    user
    account_number { "1234567890" }
    account_type   { 1 }
    balance        { 1_000 }
    CLABE          { "123456789012345678" }
  end
end
