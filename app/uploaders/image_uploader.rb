# app/uploaders/image_uploader.rb

class ImageUploader < Shrine
  plugin :activerecord
  plugin :cached_attachment_data
  plugin :restore_cached_data
  plugin :derivatives, create_on_promote: true
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      small:  magick.resize_to_limit!(300, 300),
      thumb:  magick.resize_to_fill!(100, 100),
    }
  end
end
