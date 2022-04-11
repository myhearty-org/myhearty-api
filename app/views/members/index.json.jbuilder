json.array!(@members) do |member|
  json.partial! "shared/member", member: member
end
