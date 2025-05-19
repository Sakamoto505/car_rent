class Chat < ApplicationRecord
  belongs_to :user_one, class_name:  "User"
  belongs_to :user_two, class_name:  "User"

  has_many :messages, dependent: :destroy

  def self.between(user1_id, user2_id)
    where(
      "(user_one_id = :u1 AND user_two_id = :u2) OR (user_one_id = :u2 AND user_two_id = :u1)",
      u1: user1_id, u2: user2_id
    ).first
  end

  def other_user(current_user)
    user_one_id == current_user.id ? user_two : user_one
  end
end
