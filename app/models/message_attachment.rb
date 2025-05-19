class MessageAttachment < ApplicationRecord
  include FileUploader::Attachment(:file)

  belongs_to :message

  enum attachment_type: { image: "image", file: "file" }

  validates :attachment_type, presence: true

  def image?
    attachment_type == "image"
  end
end
