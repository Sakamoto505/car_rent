class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    avatar_url = if current_user.avatar.attached?
                   url_for(current_user.avatar)
    else
                   "https://i.pravatar.cc/150?img=15"
    end

    render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes].merge(avatar_url: avatar_url), status: :ok
  end


  def all_doctors
    doctors = User.where(role: "doctor")
    render json: UserSerializer.new(doctors).serializable_hash, status: :ok
  end

  def show
    doctor = User.find_by(id: params[:id], role: "doctor")

    if doctor
      render json: UserSerializer.new(doctor).serializable_hash, status: :ok
    else
      render json: { error: "Доктор не найден" }
    end
  end

  def update
    if user_params[:avatar].present?
      current_user.avatar.attach(user_params[:avatar])
    end

    if current_user.update(user_params.except(:avatar))
      avatar_url = if current_user.avatar.attached?
                     url_for(current_user.avatar)
      else
                     "https://i.pravatar.cc/150?img=15"
      end
      render json: {
        status: { code: 200, message: "Profile updated successfully." },
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes].merge(avatar_url: avatar_url)
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Failed to update profile." },
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :middle_name, :phone, :date_of_birth, :gender, :specialization, :bio, :experience, :description_for_patient, :medical_history,  :avatar)
  end
end
