CarrierWave.configure do |config|
  require 'carrierwave/storage/abstract'
  require 'carrierwave/storage/file'
  require 'carrierwave/storage/fog'
  config.storage :fog
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region:                'ap-northeast-1',
      path_style:            true,
  }
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'public, max-age=86400'}
  case Rails.env
    when 'production'
      config.fog_directory = 'smr-production'
      config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/smr-production'
    when 'development'
      config.fog_directory = 'smr-development'
      config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/smr-development'
    when 'test'
      config.fog_directory = 'smr-development'
      config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/smr-development'
  end
end

# permit japanese filename
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:print:]\.\-\+]/

def filename
  "#{secure_token}.#{file.extension}" if original_filename.present?
end

def secure_token
  var = :"@#{mounted_as}_secure_token"
  model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
end