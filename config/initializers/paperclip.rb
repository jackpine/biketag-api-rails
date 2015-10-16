# If you try to serve images from aws.com/bucket-name, AWS redirects to the bucket-prefixed domain name.
Paperclip::Attachment.default_options[:path] = ':class/:attachment/:id_partition/:style/:filename'

if Rails.application.config.host_uploads_locally
  options = {
    storage: :fog,
    fog_credentials: {
      provider: 'Local',
      local_root: "#{Rails.root}/public"
    },
    fog_directory: 'uploads',
    fog_host: "http://#{Rails.application.config.default_host}/uploads"
  }
else
  options = {
    storage: :s3,
    url: ':s3_domain_url',
    s3_credentials: {
      bucket: ENV['AWS_S3_BUCKET'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      s3_protocol: 'https'
    }
  }
end

Paperclip::Attachment.default_options.update(options)
