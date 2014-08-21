FactoryGirl.define do
  factory :lazy_dummy do
    string { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraph }
    integer { Faker::Number.digit }
  end
end
