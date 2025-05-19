class AppointmentsController < ApplicationController
  before_action :authenticate_user!


  def index
    if params[:patient_id]
      appointments = Appointment.where(patient_id: params[:patient_id])
    elsif params[:doctor_id]
      appointments = Appointment.where(doctor_id: params[:doctor_id])
    else
      appointments = if current_user.patient?
                        current_user.patient_appointments
      else
                        current_user.doctor_appointments
      end
    end

    render json: appointments
  end

  def my_appointments
    unless current_user.patient?
      return render json: { error: "Только пациент может видеть свои записи" }, status: :forbidden
    end

    appointments = current_user.patient_appointments
                               .includes(:doctor, :availability)
                               .order("availabilities.date ASC")

    render json: appointments.map { |appointment| format_appointment(appointment) }, status: :ok
  end

  def update
    return render json: { error: "Только пациент может редактировать запись" }, status: :forbidden unless current_user.patient?

    appointment = current_user.patient_appointments.find_by(id: params[:id])
    return render json: { error: "Запись не найдена" }, status: :not_found unless appointment

    if appointment.update(notes: params[:notes])
      render json: { message: "Комментарий успешно обновлён", notes: appointment.notes }, status: :ok
    else
      render json: { error: "Не удалось обновить комментарий" }, status: :unprocessable_entity

    end
  end

  def cancel
    return render json: { error: "Только пациент может отменть запись" }, status: :forbidden unless current_user.patient?

    appointment = current_user.patient_appointments.includes(:availability).find_by(id: params[:id])

    appointment.availability.update!(booked: false)
    appointment.destroy
    render json: { message: "Ваша запись успешно отменина" }, status: :ok
  end

  def create
    return render json: { error: "Only patients can book an appointment" }, status: :forbidden unless current_user.patient?

    slot = Availability.find_by(id: params[:appointment][:availability_id], booked: false)
    return render json: { error: "Слот занят или не найден" }, status: :not_found unless slot

    appointment = Appointment.create!(
      patient: current_user,
      doctor_id: params[:appointment][:doctor_id],
      availability_id: slot.id,
      notes: params[:appointment][:notes]
    )

    slot.update!(booked: true)

    render json: {
      message: "Запись успешно создана",
      appointment_id: appointment.id,
      slot: {
        id: slot.id,
        start: slot.start_time.utc.iso8601(3),
        end: slot.end_time.utc.iso8601(3)
      }
    }, status: :created
  end



  private
  def format_appointment(appointment)
    {
      appointment_id: appointment.id,
      patient_email: current_user.email,
      doctor: {
        id: appointment.doctor.id,
        name: appointment.doctor.first_name,
        email: appointment.doctor.email
      },
      date: appointment.availability.date,
      time: format_time_range(appointment.availability),
      notes: appointment.notes
    }
  end


  def format_time_range(availability)
    "#{availability.start_time.strftime("%H:%M")} - #{availability.end_time.strftime("%H:%M")}"
  end

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :notes)
  end
end
