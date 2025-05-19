class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :created_at, :updated_at, :role, :last_name, :first_name, :middle_name,
             :phone, :date_of_birth, :gender, :specialization, :bio, :experience, :description_for_patient, :medical_history

  attribute :avatar_url do |user|
    "https://i.pravatar.cc/150?img=#{(user.id % 70) + 1}"
  end


  attribute :created_date do |user|
    user.created_at && user.created_at.strftime("%d/%m/%Y")
  end
end
