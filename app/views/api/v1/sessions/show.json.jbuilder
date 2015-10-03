json.session do
  json.api_key do
    json.partial! 'api/v1/api_keys/api_key', api_key: @api_key
  end
end
