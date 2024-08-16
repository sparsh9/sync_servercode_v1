class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers['Authorization']
    @current_doctor = Doctor.find_by(authentication_token: token)
    render json: { error: 'Not Authorized' }, status: 401 unless @current_doctor
  end

  def authorize_doctor_for_patient(patient)
    unless @current_doctor.patients.include?(patient)
      render json: { error: 'Forbidden: You are not authorized to access this resource' }, status: 403
    end
  end
end
