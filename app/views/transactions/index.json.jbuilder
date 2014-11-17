json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :pre_tip_cost, :note, :number_splitting, :tip_percentage, :post_tip
  json.url transaction_url(transaction, format: :json)
end
