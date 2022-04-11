json.array!(@charitable_aids) do |charitable_aid|
  json.partial! "shared/charitable_aid", charitable_aid: charitable_aid
end
