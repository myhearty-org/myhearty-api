return if Rails.env.production?

require Rails.root.join("app/lib/seeder")

seeder = Seeder.new
SEEDS_MULTIPLIER = [1, ENV.fetch("SEEDS_MULTIPLIER", 1).to_i].max
puts "Seeding with multiplication factor: #{SEEDS_MULTIPLIER}\n\n"

Faker::Config.locale = "en-MS"
stripe_account_id = "acct_1Kzip92RhSrnYdpM"

# Use a prebuilt list of valid addresses instead of getting random addresses from Faker::Address,
# which are mostly invalid. Valid addresses are required for the geocoding process to be performed accurately.
addresses = [
  "Jalan Bukit Bintang, Bukit Bintang, Kuala Lumpur",
  "Jalan Hijau 2/6, Bandar Tasik Puteri, Rawang, Selangor",
  "Queensbay Mall, Persiaran Bayan Indah, Bayan Lepas, Penang",
  "2, Jalan Permas 11, Bandar Baru Permas Jaya, 81750 Johor Bahru, Johor",
  "Kampung Gunung Sali, 05150 Alor Setar, Kedah",
  "Bandar Kota Bharu, Kota Bharu, Kelantan",
  "Genting Sempah, 28750 Bentong, Pahang",
  "Jalan Hang Jebat, 75200 Melaka",
  "Seremban, Negeri Sembilan",
  "Kuching, Sarawak",
  "Jalan Utara, 90000 Sandakan, Sabah"
].freeze

user_count = 10 * SEEDS_MULTIPLIER

seeder.create_if_none(User, user_count) do
  user_count.times do |i|
    user = User.new(
      name: Faker::Name.name,
      email: "user#{i + 1}@example.com",
      contact_no: "0177280300",
      address: addresses.sample,
      birth_date: Faker::Date.between(from: "1990-01-01", to: "2000-12-31"),
      gender: ["male", "female"].sample,
      password: "password",
      password_confirmation: "password",
      remember_created_at: Time.current
    )
    user.skip_confirmation!
    user.save
  end
end

charity_causes = [
  { name: "animal_welfare", display_name: "Animal Welfare" },
  { name: "arts_heritage", display_name: "Arts & Heritage" },
  { name: "children_youth", display_name: "Children & Youth" },
  { name: "community", display_name: "Community" },
  { name: "disability", display_name: "Disability" },
  { name: "education", display_name: "Education" },
  { name: "elderly", display_name: "Elderly" },
  { name: "environment", display_name: "Environment" },
  { name: "families", display_name: "Families" },
  { name: "health", display_name: "Health" },
  { name: "humanitarian", display_name: "Humanitarian" },
  { name: "social_service", display_name: "Social Service" },
  { name: "sports", display_name: "Sports" },
  { name: "women_girls", display_name: "Women & Girls" }
].freeze
categories = charity_causes.map { |charity_cause| charity_cause[:name] }

seeder.create_if_none(CharityCause) do
  charity_causes.each { |charity_cause| CharityCause.create(charity_cause) }
end

def build_lorem_flickr_image_url(width:, height:, search_terms:)
  image_source_url = "https://loremflickr.com/#{width}/#{height}/#{search_terms}?lock=#{rand(1..100000)}"
end

def build_image_data(image_url)
  Shrine.uploaded_file({
    id: image_url,
    storage: "url",
    metadata: {
      size: 10240,
      filename: "seed_image.jpg",
      mime_type: "image/jpeg"
    }
  })
end

organization_count = 10 * SEEDS_MULTIPLIER

seeder.create_if_none(Organization, organization_count) do
  random_organization_names = [
    "Admire Gifting",
    "Benefit Aid",
    "Benefit Daisy",
    "Donation Dash",
    "Easy Funds",
    "Flock Giving",
    "Foundation Fantasy",
    "Foundation Fix",
    "Friends of the Disabled Society",
    "Fund Fair",
    "Fund Flow",
    "Generation Gift",
    "Gentle Giving",
    "Gifting Hero",
    "Giving Hand",
    "Lasting Foundation",
    "Peace Assistance",
    "Sure Donations",
    "Total Help",
    "Wise Giving",
    "Wonder Foundation"
  ].freeze

  organization_count.times do |i|
    name = "#{random_organization_names.sample} #{Faker::Number.number(digits: 2)}"
    person_in_charge_name = Faker::Name.name

    organization = Organization.new(
      name: name,
      location: addresses.sample,
      email: Faker::Internet.free_email(name: name.parameterize),
      contact_no: "0177280300",
      categories: categories.sample(3),
      website_url: "https://#{name.parameterize}.my",
      facebook_url: "https://facebook.com/#{name.parameterize}",
      youtube_url: "https://youtube.com/#{name.parameterize}",
      person_in_charge_name: person_in_charge_name,
      video_url: "https://youtube.com/#{name.parameterize}",
      about_us: Faker::Lorem.paragraphs(number: 12).map { |paragraph| "<p>#{paragraph}</p>" }.join,
      programmes_summary: Faker::Lorem.paragraphs(number: 4).map { |paragraph| "<p>#{paragraph}</p>" }.join,
      charity: Faker::Boolean.boolean(true_ratio: 0.5)
    )

    organization.stripe_account_id = stripe_account_id if organization.charity?

    avatar_url = "https://www.gravatar.com/avatar/?d=identicon"
    organization.avatar_attacher.set(build_image_data(avatar_url))

    image_url = build_lorem_flickr_image_url(width: "382", height: "320", search_terms: "charity,help")
    organization.image_attacher.set(build_image_data(image_url))

    redo unless organization.save

    organization.api_keys.create

    member = organization.members.new(
      email: "admin#{i + 1}@example.com",
      password: "password",
      password_confirmation: "password",
      admin: true,
      remember_created_at: Time.current
    )
    member.skip_confirmation!
    member.save
  end
end

fundraising_campaign_count = 10 * SEEDS_MULTIPLIER

seeder.create_if_none(FundraisingCampaign, fundraising_campaign_count) do
  # A fundraising campaign is associated with a Stripe Product.
  # Delete all products associated with existing fundraising campaigns before creating new ones.
  products = Stripe::Product.list({ limit: 100 }, {
    stripe_account: stripe_account_id
  })

  products.auto_paging_each do |product|
    Stripe::Product.delete(product.id, {}, { stripe_account: stripe_account_id })
  end

  random_fundraising_campaign_names = [
    "Crowdfunding The Future",
    "The Ripple Effect",
    "For the Good of Humanity",
    "Ideas Made Real",
    "Fund Amazing Projects",
    "Crowdfunding for a Cause",
    "Giant Steps",
    "Crowdfunding the Malaysian Dream",
    "Raising Goodness",
    "Sweet Smiles",
    "The Crowdfunding Revolution",
    "Give Everything",
    "Real-life Super Heroes",
    "Your Second Home",
    "The Crowdfunding Family",
    "All for Love",
    "The Crowdfunding Bible",
    "Dear Donors",
    "The Charitable Gentlemen",
    "Holding Hands",
    "Remembering the Everyday",
    "Make Ideas Happen",
    "For The Future",
    "Raise A Future Leader",
    "Way of the Future",
    "Surpassing Hurdles",
    "Coming Together for the Future",
    "Thank a Veteran",
    "Together We Fight",
    "Hope Anonymous Project",
    "Lots of Dreams of Lost Dreams",
    "Heart for the Arts",
    "Givers for Achievers",
    "Together We Serve",
    "Heart & Sole Crowdfunding Walk",
    "Better Life Crowdfunding",
    "Brand New Life",
    "The Elite Helpers",
    "Crowdfunding 4 All",
    "Bridging The Gap",
    "The Impactful Life",
    "Ignite the Spark",
    "Every School Day Counts",
    "Money for a Cause",
    "Peace Lovers Charities",
    "Source of Hope",
    "Preparing For The Future",
    "Making the Future Better",
    "Beacon of Hope",
    "Light Up The Night"
  ].freeze

  fundraising_campaign_count.times do
    organization = Organization.find(rand(1..organization_count))
    redo unless organization.charity?

    name = "#{random_fundraising_campaign_names.sample} #{Faker::Number.number(digits: 2)}"

    fundraising_campaign = organization.fundraising_campaigns.new(
      name: name,
      target_amount: (Faker::Number.between(from: 500_000, to: 10_000_000) / 10000.0).ceil * 10000,
      categories: categories.sample(3),
      about_campaign: Faker::Lorem.paragraphs(number: 12).map { |paragraph| "<p>#{paragraph}</p>" }.join,
      youtube_url: "https://youtube.com/#{name.parameterize}",
      end_datetime: Faker::Date.between(from: 70.days.from_now, to: 190.days.from_now) + 17.hours,
      published: true
    )

    image_url = build_lorem_flickr_image_url(width: "382", height: "320", search_terms: "charity,giving")
    fundraising_campaign.image_attacher.set(build_image_data(image_url))

    fundraising_campaign.save
  end
end

donation_count = 25 * SEEDS_MULTIPLIER

seeder.create_if_none(Donation, donation_count) do
  payment_methods = [
    "alipay",
    "card",
    "fpx",
    "grabpay"
  ].freeze

  donation_count.times do |i|
    fundraising_campaign = FundraisingCampaign.find(rand(1..fundraising_campaign_count))
    donor = User.find(rand(1..user_count))
    amount = (Faker::Number.between(from: 200, to: 1_000_000) / 100.0).ceil * 100

    donation = Donation.new(
      amount: amount,
      fundraising_campaign: fundraising_campaign,
      donor: donor
    )
    donation.save

    payment = Payment.new(
      stripe_checkout_session_id: "cs_#{SecureRandom.base58(58)}",
      gross_amount: amount,
      fee: (amount * 0.03).to_i,
      net_amount: (amount * 0.97).to_i,
      payment_method: payment_methods.sample,
      status: "pending",
      completed_at: Time.current,
      donation_id: i + 1,
      fundraising_campaign: fundraising_campaign,
      user_id: donor.id
    )
    payment.save
    payment.update(status: "succeeded") # to trigger after_commit on update callback

    fundraising_campaign.update(total_raised_amount: fundraising_campaign.total_raised_amount + payment.net_amount)
  end
end

volunteer_event_count = 10 * SEEDS_MULTIPLIER

seeder.create_if_none(VolunteerEvent, volunteer_event_count) do
  random_volunteer_event_names = [
    "Backpack Heros",
    "Kits for Kids",
    "The Full Tummies Project",
    "The Little Library",
    "The Next Stage Theater",
    "Learning League",
    "Mind Masters Math Club",
    "Helping Hands and Tomatoes",
    "The Be Kind Diner",
    "Project Can-Do",
    "The Dish Network",
    "Soup for the Soul",
    "Bread and Bounty",
    "The Spoon Stewards",
    "Happy Tails",
    "Furever Friends",
    "A Pawsitive Light",
    "Spay-ghetti Dinner",
    "Give Back Summer",
    "March for a Cause",
    "Summer of Volunteering",
    "Spring Forward",
    "Spring Into Action",
    "School's Out Academy",
    "Voltober",
    "Project Forever Thankful",
    "The Season of Giving Project",
    "Festival of Trees ",
    "The Gift of Play Toy Drive"
  ].freeze

  volunteer_event_count.times do
    organization = Organization.find(rand(1..organization_count))
    name = "#{random_volunteer_event_names.sample} #{Faker::Number.number(digits: 2)}"
    datetime = Faker::Date.between(from: 70.days.from_now, to: 190.days.from_now)

    volunteer_event = organization.volunteer_events.new(
      name: name,
      openings: Faker::Number.between(from: 5, to: 10),
      location: addresses.sample,
      categories: categories.sample(3),
      about_event: Faker::Lorem.paragraphs(number: 12).map { |paragraph| "<p>#{paragraph}</p>" }.join,
      youtube_url: "https://youtube.com/#{name.parameterize}",
      start_datetime: datetime + 10.hours,
      end_datetime: datetime + 13.hours,
      application_deadline: datetime - 1.months,
      published: true
    )

    image_url = build_lorem_flickr_image_url(width: "382", height: "320", search_terms: "volunteer,community")
    volunteer_event.image_attacher.set(build_image_data(image_url))

    volunteer_event.save
  end
end

volunteer_application_count = 25 * SEEDS_MULTIPLIER

seeder.create_if_none(VolunteerApplication, volunteer_application_count) do
  attendance = %i[absent present]

  volunteer_application_count.times do
    volunteer_event = VolunteerEvent.find(rand(1..volunteer_event_count))
    redo if volunteer_event.volunteer_count_exceeded?

    volunteer = User.find(rand(1..user_count))

    volunteer_application = VolunteerApplication.where(volunteer_event: volunteer_event, volunteer: volunteer)
                                                .first_or_initialize
    volunteer_application.save
    volunteer_application.update(status: "confirmed", attendance: attendance.sample) # to trigger after_commit on update callback
  end
end

charitable_aid_count = 10 * SEEDS_MULTIPLIER

seeder.create_if_none(CharitableAid, charitable_aid_count) do
  random_charitable_aid_names = [
    "Aid for Children",
    "Aid for Housewives",
    "Single Mother Aid",
    "Assistance for Senior Citizen",
    "Acquiring Support for Disabled",
    "Applying Medical Help",
    "Poverty Scholarship",
    "Scholarships Focusing on Low Income Students and Families",
    "Free Textbooks",
    "Back to School Aid",
    "Community Aid & Sponsorship Programme (CASP)",
    "Monthly Meal Delivery",
    "Good of the Month",
    "Girls Coding Camp",
    "Summer Feeding Programme",
    "Primary School Tuition",
    "Secondary School Tuition",
    "Taking Care of the Elderly",
    "Power Up Girls",
    "Food Aid",
    "Youth Talent Programme"
  ].freeze

  charitable_aid_count.times do
    organization = Organization.find(rand(1..organization_count))
    name = "#{random_charitable_aid_names.sample} #{Faker::Number.number(digits: 2)}"

    charitable_aid = organization.charitable_aids.new(
      name: name,
      openings: Faker::Number.between(from: 5, to: 10),
      location: addresses.sample,
      categories: categories.sample(3),
      about_aid: Faker::Lorem.paragraphs(number: 12).map { |paragraph| "<p>#{paragraph}</p>" }.join,
      youtube_url: "https://youtube.com/#{name.parameterize}",
      application_deadline: Faker::Date.between(from: 70.days.from_now, to: 190.days.from_now) + 23.hours,
      published: true
    )

    image_url = build_lorem_flickr_image_url(width: "382", height: "320", search_terms: "gift,give")
    charitable_aid.image_attacher.set(build_image_data(image_url))

    charitable_aid.save
  end
end

charitable_aid_application_count = 25 * SEEDS_MULTIPLIER

seeder.create_if_none(CharitableAidApplication, charitable_aid_application_count) do
  charitable_aid_application_count.times do
    charitable_aid = CharitableAid.find(rand(1..charitable_aid_count))
    redo if charitable_aid.receiver_count_exceeded?

    receiver = User.find(rand(1..user_count))

    charitable_aid_application = CharitableAidApplication.where(charitable_aid: charitable_aid, receiver: receiver)
                                                         .first_or_initialize(reason: "I would like to apply for this charitable aid.")
    charitable_aid_application.save
    charitable_aid_application.update(status: "approved") # to trigger after_commit on update callback
  end
end

puts "\nFinished seeding data"
