# frozen_string_literal: true

class RecipeService
  include HTTParty
  base_uri 'http://www.recipepuppy.com'

  def recipes(query, page = 1)
    options = {
      query: { q: query, page: page }
    }

    begin
      res = self.class.get('/api', options)
      res.success? ? normalize_response(res) : normalize_error(res.code, res.message, res.body)
    rescue HTTParty::Error, SocketError, Timeout::Error => e
      handle_conn_error(e)
    end
  end

  private

  def normalize_response(res)
    json = JSON.parse(res, symbolize_names: true)

    recipes = json[:results].map do |item|
      recipe = Recipe.new
      recipe.href = item[:href]
      recipe.title = item[:title]
      recipe.ingredients = item[:ingredients]
      recipe.thumbnail = item[:thumbnail]
      recipe
    end

    options = {
      meta: { total: recipes.count }
    }
    RecipeSerializer.new(recipes, options).serializable_hash.to_json
  end

  def normalize_error(code, title, detail)
    [{
      status: code,
      source: { external_api: self.class.base_uri },
      title: title,
      detail: detail
    }]
  end

  def handle_conn_error(err)
    title = "Cannot connect to the API #{self.class.base_uri}"
    normalize_error(500, title, err.message)
  end
end
