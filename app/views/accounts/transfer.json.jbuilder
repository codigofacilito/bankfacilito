json.message 'Transferencia realizada con éxito'

json.amount @amount

json.source_account do
  json.extract! @source_account, :account_number
end

json.recipient_account do
  json.extract! @recipient_account, :account_number
end