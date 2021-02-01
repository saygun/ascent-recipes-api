# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :sanitize_params, only: [:index]
  before_action :validate_params, only: [:index]

  def index
    recipe_service = RecipeService.new
    response = recipe_service.recipes(params[:q], params[:page])
    render json: response
  end

  private

  def sanitize_params
    params[:page] = params[:page].to_i if params[:page]
    params[:q] = params[:q].strip if params[:q]
  end

  def validate_params
    errors = []
    if params[:q].nil?
      errors.push({
                    source: { parameter: 'q' },
                    title: 'Invalid Query Parameter',
                    detail: 'The query parameter "q" must be present'
                  })
    end

    if params[:page] && params[:page] < 1
      errors.push({
                    source: { parameter: 'page' },
                    title: 'Invalid Query Parameter',
                    detail: 'The query parameter "page" must be numeric and greater than zero'
                  })
    end

    render json: { errors: errors }, status: :bad_request if errors.size.positive?
  end
end
