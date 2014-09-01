module ApplicationHelper
  TRANSFORMS = {
    'notice'  => 'alert-info',
    'success' => 'alert-success',
    'error'   => 'alert-danger'
  }

  def current_user
    @current_user ||= User.where(id: session['auth.entity_id']).first
  end

  def flash_transform(type)
    TRANSFORMS[type]
  end
end
