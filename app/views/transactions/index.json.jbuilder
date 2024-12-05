json.message 'Transferencia realizada con éxito'
json.source_account do
  json.extract! @source_account, :id, :account_number, :balance
end
json.recipient_account do
  json.account_number params[:recipient_account_number]
end