# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe 'GET index' do
    it 'renders missing query parameter error when param "q" is not present' do
      get '/recipes', params: { page: 1 }

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:bad_request)
      expect(body['errors'][0]['detail']).to eq('The query parameter "q" must be present')
    end

    it 'renders missing query parameter error when param "page" is not numeric' do
      get '/recipes', params: { q: 'foo', page: -1 }

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:bad_request)
      expect(body['errors'][0]['detail']).to eq('The query parameter "page" must be numeric and greater than zero')
    end

    it 'renders 20 item of recipes that returned by RecipeService' do
      recipes = FactoryBot.build_list(:recipe, 21)

      stub_request(:get, 'http://www.recipepuppy.com/api?page=1&q=foo')
        .to_return(
          status: 200,
          body: JSON.generate({ results: recipes }),
          headers: {
            'Content-Type': 'text/javascript'
          }
        )

      get '/recipes', params: { q: 'foo' }
      body = JSON.parse(response.body)

      expect(body['data'].length).to eq(20)
    end
  end
end
