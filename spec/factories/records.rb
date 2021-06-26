FactoryBot.define do
  factory :record do
    record_at { '2021-06-21' }
    body_temperature { 36.5}
    is_cough { "なし"}
    is_sneeze { "する"}
    is_runny_nose { "出る"}
    is_dull { "だるくない"}
    is_family_illness { "いない"}
    attendance { "欠席"}
  end
  factory :record2, class: Record do
    record_at { '2021-06-25' }
    body_temperature { 37.0}
    is_cough { "あり"}
    is_sneeze { "する"}
    is_runny_nose { "出る"}
    is_dull { "だるい"}
    is_family_illness { "いない"}
    attendance { "欠席"}
    # association :user, factory: :user
    association :student, factory: :student
  end
factory :record3, class: Record do
  record_at { '2021-06-23' }
  body_temperature { 36.2}
  is_cough { "なし"}
  is_sneeze { "する"}
  is_runny_nose { "出る"}
  is_dull { "だるくない"}
  is_family_illness { "いる"}
  attendance { "出席"}
  # association :user, factory: :user
  association :student, factory: :student
end

# factory :record2,class: Record do
#   record_at { '2021-06-10' }
#   body_temperature { 37.0}
#   association :student, factory: :student2
# end
# factory :record3,class: Record do
#   record_at { '2021-04-21' }
#   body_temperature { 36.1}
#   association :student, factory: :student3
# end
end
