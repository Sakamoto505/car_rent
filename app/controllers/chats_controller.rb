class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    chats = Chat.where("user_one_id = :id OR user_two_id = :id", id: current_user.id)
    render json: chats.map { |chat|
      {
        id: chat.id,
        user: chat.other_user(current_user)&.slice(:id, :first_name, :last_name, :role, :specialization)
      }
    }
  end

  def create
    unless params[:user_id].present?
      return render json: { error: "user_id required" }, status: :bad_request
    end

    other_user = User.find_by(id: params[:user_id])
    unless other_user
      return render json: { error: "User not found" }, status: :not_found
    end


    appointments_exists = Appointment.exists?(
      patient_id: current_user.id,
      doctor_id: other_user.id
    ) || Appointment.exists?(
      patient_id: other_user.id,
      doctor_id: current_user.id
    )
    unless appointments_exists
      return render json: { error: "Нельзя начать чат без записи к врачу" }, status: :forbidden
    end

    chat = Chat.between(current_user.id, other_user.id) || Chat.create!(
      user_one: current_user,
      user_two: other_user
    )

    render json: { id: chat.id }
  end


  def show
    chat = Chat.find(params[:id])
    if chat.user_one == current_user || chat.user_two == current_user
      render json: {
        id: chat.id,
        participants: [ chat.user_one, chat.user_two ].map { |u| u.slice(:id, :first_name, :last_name, :role) }
      }
    else
      head :forbidden
    end
  end
end
