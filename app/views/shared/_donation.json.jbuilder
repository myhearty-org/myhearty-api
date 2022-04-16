json.extract! donation,
  :id,
  :donation_id
json.amount number_with_precision(donation.amount.to_f / 100, precision: 2)
json.gross_amount number_with_precision(donation.gross_amount.to_f / 100, precision: 2)
json.fee number_with_precision(donation.fee.to_f / 100, precision: 2)
json.net_amount number_with_precision(donation.net_amount.to_f / 100, precision: 2)
json.extract! donation,
  :payment_method,
  :status,
  :completed_at
