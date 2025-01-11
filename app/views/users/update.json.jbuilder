json.user do
  json.extract! @current_user, :id, :first_name, :last_name, :email
end
