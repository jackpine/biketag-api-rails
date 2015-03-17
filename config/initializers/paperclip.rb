# If you try to serve images from aws.com/bucket-name, AWS redirects to the bucket-prefixed domain name.
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'

if Rails.env.test?
  options = {
    storage: :fog,
    fog_credentials: {
      provider: 'Local',
      local_root: "#{Rails.root}/public/uploads"
    },
    fog_directory: '',
    fog_host: 'http://localhost:3000'
  }
else
  options = {
    storage: :s3,
    url: ':s3_domain_url',
    s3_credentials: {
      bucket: ENV['AWS_S3_BUCKET'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  }
end

Paperclip::Attachment.default_options.update(options)
