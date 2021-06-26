FactoryBot.define do
  factory :student do
    student_name { 'むさし' }
    school_year { '2年生' }
  end
  factory :student2,class: Student do
    student_name { 'こじろう' }
    school_year { '1年生' }
    association :user, factory: :user2

  end
  factory :student3,class: Student do
    student_name { 'またはち' }
    school_year { '3年生' }
    association :user, factory: :user3
  end
end
