class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticated?
    !!session['auth.entity_id']
  end

  def current_user
    @current_user ||= User.where(id: session['auth.entity_id']).first
  end
end
