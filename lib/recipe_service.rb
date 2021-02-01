# frozen_string_literal: true

class RecipeService
  BASE_URI = 'http://www.recipepuppy.com'

  def initialize
    @conn = Faraday.new do |builder|
      builder.use :http_cache, store: Rails.cache, logger: ActiveSupport::Logger.new(STDOUT)
      builder.use Faraday::OverrideCacheControl, cache_control: 'public, max-age=3600'
      builder.response :json, content_type: 'text/javascript'
      builder.adapter Faraday.default_adapter
    end
  end

  def recipes(query, page = 1, limit = 20)
    begin
      res = @conn.get("#{BASE_URI}/api") do |req|
        req.params = { q: query, page: page }
      end

      res.success? ? normalize_response(res.body)[0, limit] : normalize_error(res.status, res.body)
    rescue SocketError, Timeout::Error => e
      handle_conn_error(e)
    end
  end

  private

  def normalize_response(body)
    body['results'].map do |item|
      recipe = Recipe.new
      recipe.href = item['href']
      recipe.title = item['title']
      recipe.ingredients = item['ingredients']
      recipe.thumbnail = item['thumbnail']
      recipe
    end
  end

  def normalize_error(code, detail)
    [{
      status: code,
      source: { external_api: BASE_URI },
      detail: detail
    }]
  end

  def handle_conn_error(err)
    title = "Cannot connect to the API #{BASE_URI}"
    normalize_error(500,  err.message)
  end
end
