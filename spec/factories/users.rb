FactoryBot.define do
  factory :user do
    first_name { "Admin" }
    last_name  { "User" }
    pin_digest { "1234" }
  end
end
