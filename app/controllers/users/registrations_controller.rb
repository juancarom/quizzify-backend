# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: {
          status: { code: 200, message: 'Usuario creado exitosamente.' },
          data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }, status: :ok
      else
        render json: {
          status: { message: "El usuario no pudo ser creado.", errors: resource.errors.full_messages },
        }, status: :unprocessable_entity
      end
    end
  end
end
