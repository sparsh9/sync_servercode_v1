class PatientsController < ApplicationController
  before_action :set_doctor
  before_action :set_patient, only: [:update, :destroy, :show]
  before_action :authorize_doctor_for_patient, only: [:update, :destroy, :show]

  def index
    @patients = @doctor.patients
    render json: @patients
  end

  def create
    @patient = Patient.find_or_initialize_by(patient_params.except(:id))
    @patient.doctors << @doctor unless @patient.doctors.include?(@doctor)

    if @patient.save
      render json: @patient, status: :created
    else
      render json: @patient.errors, status: :unprocessable_entity
    end
  end

  def update
    if @patient.update(patient_params)
      render json: @patient
    else
      render json: @patient.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    head :no_content
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:doctor_id])
  end

  def set_patient
    @patient = @doctor.patients.find_by(id: params[:id])
    render json: { error: 'Patient not found' }, status: 404 unless @patient
  end

  def patient_params
    params.require(:patient).permit(:name, :medical_history, :sync_status)
  end
end
