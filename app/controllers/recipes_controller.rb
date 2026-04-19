class RecipesController < ApplicationController
  def new
  end

  def create
    ingredients = params[:ingredients]

    begin
      service = GeminiService.new
      prompt = "「#{ingredients}」という食材を使った、家庭で簡単に作れるレシピを1つ提案してください。以下のJSON形式で、キーや値の型も完全に守って応答してください。\n\n{\n  \"recipeName\": \"料理名\",\n  \"description\": \"料理の簡単な説明\",\n  \"ingredients\": [\n    { \"name\": \"材料名\", \"quantity\": \"分量\" }\n  ],\n  \"instructions\": [\n    \"手順1\",\n    \"手順2\"\n  ]\n}"
      
      response_text = service.generate_content(prompt)
      @recipe = JSON.parse(response_text)
    rescue JSON::ParserError => e
      @error = "レシピの形式が不正です: #{e.message}"
    rescue => e
      @error = "レシピの生成に失敗しました: #{e.message}"
    end
  end
end
