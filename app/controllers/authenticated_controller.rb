class AuthenticatedController < ApplicationController
  def authenticated?
    !!session['auth.entity_id']
  end

  def current_user
    @current_user ||= User.where(id: session['auth.entity_id']).first
  end
end
