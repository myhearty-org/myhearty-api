json.array!(@charitable_aids) do |charitable_aid|
  json.partial! "charitable_aids/charitable_aid", charitable_aid: charitable_aid
end
