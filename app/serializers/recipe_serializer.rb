# frozen_string_literal: true

class RecipeSerializer
  include JSONAPI::Serializer

  set_id :title do |record|
    Digest::MD5.hexdigest record.href
  end
  attributes :title, :href, :ingredients
  attribute :thumbnail, if: proc { |record| record.thumbnail.present? }
end
