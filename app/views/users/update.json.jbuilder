json.user do
  json.extract! @user, :id, :first_name, :last_name, :email
end
