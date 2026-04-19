require "openai"

class RecipesController < ApplicationController
  def new
  end

  def create
    ingredients = params[:ingredients]

    prompt = <<-PROMPT
    「#{ingredients}」という食材を使った、家庭で簡単に作れるレシピを1つ提案してください。
    以下のJSON形式で、キーや値の型も完全に守って応答してください。

    {
      "recipeName": "料理名",
      "description": "料理の簡単な説明",
      "ingredients": [
        { "name": "材料名", "quantity": "分量" }
      ],
      "instructions": [
        "手順1",
        "手順2"
      ]
    }
    PROMPT

    begin
      client = OpenAI::Client.new(api_key: Rails.application.credentials.openai_api_key)

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: prompt }],
          response_format: { type: "json_object" },
          temperature: 0.7,
        }
      )

      raw_response = response.dig("choices", 0, "message", "content")
      @recipe = JSON.parse(raw_response)
    rescue => e
      @error = "レシピの生成に失敗しました: #{e.message}"
    end
  end
end
