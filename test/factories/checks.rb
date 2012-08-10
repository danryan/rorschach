# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :check do
    metric "MyString"
    warning "9.99"
    critical "9.99"
    resolve false
    repeat false
    interval 1
  end
end
