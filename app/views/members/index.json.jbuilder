json.array!(@members) do |member|
  json.partial! "members/member", member: member
end
