FactoryBot.define do
  factory :post do
    title { "MyString" }
    content { "MyString" }
    status { 1 }
    user { nil }
  end
end
