# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| Faker::Internet.safe_email(name: "user_#{n}") }
    password { 'test1234' }
  end
end
