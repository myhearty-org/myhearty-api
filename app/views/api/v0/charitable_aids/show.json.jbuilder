json.partial! "shared/charitable_aid", charitable_aid: @charitable_aid
if current_member
  json.image_data @charitable_aid.image_data
  json.approval_email_body @charitable_aid.approval_email_body
end
json.organization do
  json.partial! "api/v0/shared/organization", organization: @charitable_aid.organization
end
