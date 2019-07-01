FactoryBot.define do
  factory :profile do
    
  end

  factory :attachment do
    
  end

  factory :user do
    email { "MyString" }
    phone_number { "MyString" }
    code_country { "MyString" }
    tokens { "" }
    is_verified { false }
  end

  
end
