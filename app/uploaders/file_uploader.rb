class FileUploader < Shrine
  plugin :determine_mime_type
  plugin :store_dimensions, analyzer: :mini_magick
  plugin :validation_helpers
  plugin :remove_attachment
end
