# config/initializers/openai.rb
openai_credentials = Rails.application.credentials.dig(:openai) || Rails.application.credentials.dig(:openai_api_key)

if openai_credentials
  if openai_credentials.is_a?(Hash)
    OpenAI.configure do |config|
      config.access_token = openai_credentials[:api_key]
    end
  else
    OpenAI.configure do |config|
      config.access_token = openai_credentials
    end
  end
end