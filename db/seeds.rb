# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create the default Account
user = User.find_or_create_by!(
    first_name: 'Admin',
    last_name: 'Admin',
    pin_digest: '1234',
)

Account.find_or_create_by!(
    user_id: user.id, 
    account_number: '1234567890', 
    account_type: 1, 
    balance: 1_000_000_000, 
    CLABE: '123456789012345678'
)