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

  validates :account, uniqueness: { scope: :user, message: "El destinatario ya existe" }

  attr_accessor :clabe

  before_validation :set_account_from_clabe, unless: :account

  private

  def set_account_from_clabe
    self.account = Account.find_by(clabe: clabe) if clabe
  end
end
