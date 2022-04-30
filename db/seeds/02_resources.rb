# Create a default list of charity causes

CharityCause.create!(name: "animal_welfare", display_name: "Animal Welfare")
CharityCause.create!(name: "arts_heritage", display_name: "Arts & Heritage")
CharityCause.create!(name: "children_youth", display_name: "Children & Youth")
CharityCause.create!(name: "community", display_name: "Community")
CharityCause.create!(name: "disability", display_name: "Disability")
CharityCause.create!(name: "education", display_name: "Education")
CharityCause.create!(name: "elderly", display_name: "Elderly")
CharityCause.create!(name: "environment", display_name: "Environment")
CharityCause.create!(name: "families", display_name: "Families")
CharityCause.create!(name: "health", display_name: "Health")
CharityCause.create!(name: "humanitarian", display_name: "Humanitarian")
CharityCause.create!(name: "social_service", display_name: "Social Service")
CharityCause.create!(name: "sports", display_name: "Sports")
CharityCause.create!(name: "women_girls", display_name: "Women & Girls")

# Create a dummy organization

Organization.create!(
  name: "Love Charity",
  location: "Kuala Lumpur",
  email: "hello@love_charity.com",
  contact_no: "60342805673",
  website_url: "https://lovecharity.my",
  facebook_url: "https://facebook.com/love_charity",
  youtube_url: "https://youtube.com/love_charity",
  person_in_charge_name: "Mr. Wong",
  about_us: "This is Love Charity"
)
