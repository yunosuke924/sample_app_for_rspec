FactoryBot.define do
  factory :task do
    sequence(:title,"title_1")
    content { "content" }
    status {1}
    deadline { 1.week.from_now }
    association :user
  end
end
