class ApplicationController < ActionController::Base
  before_action :require_login

  def not_authenticated
    redirect_to login_path, alert: 'Login required'
  end
end
