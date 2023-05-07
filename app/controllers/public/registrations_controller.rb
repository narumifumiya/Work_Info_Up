# frozen_string_literal: true

class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
 
 def after_sign_in_path_for(resource)
    public_user_path(current_user)
 end



 protected

 def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :name_kana, :email, :phone_number])
 end
end
