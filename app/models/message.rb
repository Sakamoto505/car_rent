class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, class_name:  "User"

  has_many :attachments, class_name: "MessageAttachment", dependent: :destroy
  accepts_nested_attributes_for :attachments

  enum message_type: { text: 0, file: 1, image: 2 }
end
