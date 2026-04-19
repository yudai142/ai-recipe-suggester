class GeminiService
  def initialize
    @api_key = Rails.application.credentials.dig(:gemini, :api_key)
    raise "Gemini API key is not configured" unless @api_key
  end

  def generate_recipe_suggestion(ingredients)
    prompt = "以下の材料でレシピを提案してください: #{ingredients.join(', ')}"
    generate_content(prompt)
  end

  def analyze_recipe(recipe_text)
    prompt = "以下のレシピを分析して、栄養価やカロリーの推定などを教えてください:\n#{recipe_text}"
    generate_content(prompt)
  end

  def suggest_shopping_list(dietary_preferences)
    prompt = "以下の食事制限に基づいて、買い物リストを作成してください: #{dietary_preferences}"
    generate_content(prompt)
  end

  def generate_content(prompt)
    require 'net/http'
    require 'json'

    Rails.logger.info "API Key check: #{@api_key.present? ? "Present (#{@api_key[0..5]}...)" : 'Missing'}"
    
    uri = URI("https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent?key=#{@api_key}")
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Post.new(uri.path + "?key=#{@api_key}")
    request['Content-Type'] = 'application/json'
    
    body = {
      contents: [{
        parts: [{ text: prompt }]
      }]
    }
    
    request.body = body.to_json
    
    response = http.request(request)
    
    if response.code == "200"
      result = JSON.parse(response.body)
      result.dig("candidates", 0, "content", "parts", 0, "text") || "回答を取得できませんでした"
    else
      raise "Gemini API error: #{response.code} - #{response.body}"
    end
  end
end