class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def index
    messages = @chat.messages.includes(:sender, :attachments).order(:created_at)
    render json: messages.map { |msg|
      {
        id: msg.id,
        content: msg.content,
        message_type: msg.message_type,
        attachments: msg.attachments.map do |attachment|
          {
            type: attachment.attachment_type,
            name: attachment.file.metadata["filename"],
            url: attachment.file_url,
            thumb_url: attachment.image? ? attachment.file_url(:thumb) : nil
          }.compact
        end,
        sender: {
          id: msg.sender.id,
          first_name: msg.sender.first_name,
          role: msg.sender.role
        },
        created_at: msg.created_at
      }
    }
  end


  def create
    message_type = params[:message_type] || "text"

    message = @chat.messages.new(
      sender: current_user,
      message_type: message_type,
      content: message_type == "text" ? params[:content] : nil
    )

    message.save!

    if %w[file image].include?(message_type) && params[:attachments].present?
      Array(params[:attachments]).each do |uploaded_file|

        mime_type = Marcel::MimeType.for(uploaded_file, name: uploaded_file.original_filename)

        unless message_type == "file" || mime_type.start_with?("image")
          return render json: {
            error: "Ожидались изображения, но получен файл типа #{mime_type}"
          }, status: :unprocessable_entity
        end

        message.attachments.create!(

          file: uploaded_file,
          attachment_type: message_type
        )
      end
    end

    payload = {
      id: message.id,
      content: message.content,
      message_type: message.message_type,
      attachments: message.attachments.map do |att|
        {
          url: att.file_url,
          thumb_url: att.file_url(:thumb),
          name: att.file&.original_filename,
          type: att.attachment_type
        }
      end,
      sender: {
        id: current_user.id,
        first_name: current_user.first_name,
        role: current_user.role
      },
      created_at: message.created_at
    }

    ChatChannel.broadcast_to(@chat, payload)
    end



    private

  def set_chat
    @chat = Chat.find(params[:chat_id])
    unless [ @chat.user_one_id, @chat.user_two_id ].include?(current_user.id)
      head :forbidden
    end
  end
end
