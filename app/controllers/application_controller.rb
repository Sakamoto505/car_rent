class ApplicationController < ActionController::API
   before_action :configure_permitted_parameters, if: :devise_controller?

    private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [
        :last_name, :first_name, :middle_name, :role,
        :phone, :date_of_birth, :gender, :specialization
      ])

      devise_parameter_sanitizer.permit(:account_update, keys: [
        :last_name, :first_name, :middle_name, :role,
        :phone, :date_of_birth, :gender, :specialization
      ])
    end
end
