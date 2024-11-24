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
class User < ApplicationRecord
   has_many :accounts

   validates :email, allow_blank: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

   def to_s
      "#{first_name} #{last_name}"
   end
end
