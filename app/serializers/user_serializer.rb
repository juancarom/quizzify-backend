# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :name, :avatar_url, :role, :created_at
end
