require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # временное
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # постоянное
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :derivatives
# Shrine.plugin :derivation_endpoint
Shrine.plugin :validation_helpers
Shrine.plugin :pretty_location
Shrine.plugin :instrumentation
Shrine.plugin :upload_endpoint

Shrine.logger = Rails.logger
