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

agua_account = Account.create!(balance: 0, account_type: :service)
luz_account = Account.create!(balance: 0, account_type: :service)
internet_account = Account.create!(balance: 0, account_type: :service)

Service.create!(name: 'Agua', description: 'Pago del servicio de agua', account: agua_account)
Service.create!(name: 'Luz', description: 'Pago del servicio de luz', account: luz_account)
Service.create!(name: 'Internet', description: 'Pago del servicio de internet', account: internet_account)
