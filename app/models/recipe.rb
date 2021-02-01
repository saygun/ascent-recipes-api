# frozen_string_literal: true

class Recipe
  attr_accessor :id, :title, :href, :ingredients, :thumbnail

  def to_json(options)
    {
      id: self.id,
      title: self.title,
      href: self.href,
      ingredients: self.ingredients,
      thumbnail: self.thumbnail
    }.to_json
  end
end
