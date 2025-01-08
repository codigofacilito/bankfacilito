json.message 'Usuario registrado exitosamente'
json.token @token

json.user do
  json.extract! @user, :id, :first_name, :last_name, :email
end

json.account do
  json.extract! @account, :account_number, :balance, :clabe
end