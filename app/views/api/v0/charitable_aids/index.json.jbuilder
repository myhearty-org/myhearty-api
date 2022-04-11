json.array!(@charitable_aids) do |charitable_aid|
  json.partial! "charitable_aids/charitable_aid", charitable_aid: charitable_aid

  if charitable_aid.association_cached?(:organization)
    json.organization do
      json.partial! "api/v0/shared/organization", organization: charitable_aid.organization
    end
  end
end
