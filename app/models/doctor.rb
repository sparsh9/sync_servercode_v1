class Doctor < ApplicationRecord
  has_many :doctor_patients
  has_many :patients, through: :doctor_patients

  before_create :generate_authentication_token

  private

  def generate_authentication_token
    self.authentication_token = SecureRandom.hex(20)
  end
end
