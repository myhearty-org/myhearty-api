json.partial! "charitable_aids/charitable_aid", charitable_aid: @charitable_aid
json.organization do
  json.partial! "api/v0/shared/organization", organization: @charitable_aid.organization
end
