# If you try to serve images from aws.com/bucket-name, AWS redirects to the bucket-prefixed domain name.
Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'

Paperclip::Attachment.default_options[:storage] = :fog
Paperclip::Attachment.default_options[:fog_credentials] = {:provider => "Local", :local_root => "#{Rails.root}/public"}
Paperclip::Attachment.default_options[:fog_directory] = ""
Paperclip::Attachment.default_options[:fog_host] = "http://localhost:3000"
Paperclip::Attachment.default_options[:s3_credentials] = {
  :bucket => ENV['AWS_S3_BUCKET'],
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
}

