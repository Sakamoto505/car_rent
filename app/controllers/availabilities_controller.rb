class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!

  def create
    return render json: { error: "Только врач может выставить график" }, status: :forbidden unless current_user.doctor?

    AvailabilityService.create_availabilities(current_user, params[:slots])

    saved_slots = current_user.availabilities.order(:start_time).map do |slot| {
      id: slot.id,
      start: slot.start_time.utc.iso8601(3),
      end: slot.end_time.utc.iso8601(3),
      booked: slot.booked,
      booking: nil
    }
    end
    render json: {
      message: "График врача сохранён",
      slots: saved_slots
    }, status: :created  end

  def destroy_slots
    return render json: { error: "Только врач может удалять слоты" }, status: :forbidden unless current_user.doctor?

    slot_ids = params[:slot_ids]

    return render json: { error: "Нужно передать slot_ids" }, status: :bad_request if slot_ids.blank?

    slots = current_user.availabilities.where(id: slot_ids)

    if slots.empty?
      return render json: { error: "Слоты не найдены или не принадлежат вам" }, status: :not_found
    end

    booked_slots = slots.select(&:booked?)
    if booked_slots.any?
      return render json: { error: "Есть занятые слоты, удалить можно только свободные" }, status: :forbidden
    end

    slots.destroy_all
    render json: { message: "Слоты успешно удалены" }, status: :ok
  end



  def my_availabilities
    doctor = current_user
    availabilities = doctor.availabilities.includes(appointment: :patient).order(:date, :start_time)

    result = availabilities.map do |slot|
      slot_data = {
        id: slot.id,
        start: slot.start_time.utc.iso8601(3),
        end: slot.end_time.utc.iso8601(3),
        booked: slot.booked,
        booking: nil
      }

      if slot.booked? && slot.appointment.present?
        patient = slot.appointment.patient
        slot_data[:booking] = {
          bookingId: slot.appointment.id,
          patientId: patient.id,
          patientName: "#{patient.first_name} #{patient.last_name}",
          comment: slot.appointment.notes
        }
      end

      slot_data
    end

    render json: result, status: :ok
  end


  def index
    doctor = User.find_by(id: params[:doctor_id])
    return render json: [] unless doctor

    availabilities = doctor.availabilities.where(booked: false).order(:start_time)

    slots = availabilities.map do |slot|
      {
        id: slot.id,
        start: slot.start_time.utc.iso8601(3),
        end: slot.end_time.utc.iso8601(3)
      }
    end

    render json: slots, status: :ok
  end
end
