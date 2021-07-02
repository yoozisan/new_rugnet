class Record < ApplicationRecord
  belongs_to :student
  validates :record_at, presence: true
  validates :body_temperature, presence: true, length: { maximum: 4 }
  validate :record_date_cannot_be_in_the_future
  def record_date_cannot_be_in_the_future
    if record_at.present? && record_at > Date.today
      errors.add(:record_at, "は未来を入力できません。")
    end
  end
  validate :body_temperature_validate
  def body_temperature_validate
		errors.add(:body_temperature, "は35.0℃より高くなければなりません。") unless body_temperature.nil? || body_temperature > 35.0
    errors.add(:body_temperature, "は42.0℃より低くなければなりません。") unless body_temperature.nil? || body_temperature < 42.0
	end

  enum is_cough: { なし:false, あり:true }
  enum is_sneeze: { しない:false, する:true }
  enum is_runny_nose: { 出ない:false, 出る:true }
  enum is_dull: { だるくない:false, だるい:true }
  enum is_family_illness: { いない:false, いる:true }
  enum attendance: {欠席:0, 出席:1 }
end
