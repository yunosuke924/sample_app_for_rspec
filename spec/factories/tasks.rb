FactoryBot.define do
  factory :task do
    title {'Doing Homework'}
    status {1}
    association :user
  end
end
