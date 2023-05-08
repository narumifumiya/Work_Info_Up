# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    admin_root_path
  end

end
