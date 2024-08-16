class SyncController < ApplicationController
  before_action :set_doctor
  before_action :authorize_doctor_for_sync, only: [:sync_data]

  def sync_data
    sync_results = []
    ActiveRecord::Base.transaction do
      params[:patients].each do |patient_data|
        patient = Patient.find_or_initialize_by(id: patient_data[:id])
        patient.doctors << @doctor unless patient.doctors.include?(@doctor)

        if patient.update(name: patient_data[:name], medical_history: patient_data[:medical_history], sync_status: patient_data[:sync_status], timestamp: patient_data[:timestamp])
          sync_results << { id: patient.id, status: 'synced' }
        else
          sync_results << { id: patient.id, status: 'conflict' }
          SyncLog.create!(doctor: @doctor, patient: patient, sync_status: 'conflict', details: 'Conflict detected during sync')
        end
      end
    end

    render json: { results: sync_results }, status: :ok
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:doctor_id])
  end

  def authorize_doctor_for_sync
    if params[:patients].any? { |data| !@doctor.patients.exists?(id: data[:id]) }
      render json: { error: 'Forbidden: You are not authorized to access some of the resources' }, status: 403
    end
  end

  def patient_params(patient_data)
    patient_data.slice(:name, :medical_history, :sync_status, :timestamp)
  end
end
