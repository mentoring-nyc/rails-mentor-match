class SignupController < AuthenticatedController
  def benefits
  end

  def complete_profile
    @profile = current_user.profile || current_user.profile_from_identity
  end

  def complete_profile_submission
    @profile = current_user.profile || current_user.profile_from_identity
    @profile.attributes = update_params.merge(role: session['auth.signup.role'])
    @profile.save

    if @profile.errors.present?
      @profile.errors.full_messages.each do |message|
        flash.now[:error] = message
      end

      render :'signup/complete_profile'
    else
      redirect_to signup_success_path
    end
  end

  def define_role
    if Profile::ROLES.include? params[:role].downcase
      session['auth.signup.role'] = params[:role].downcase
      redirect_to '/auth/github?redirect_uri=/signup/complete-profile'
    end
  end

  def success
  end

  def welcome
  end

  private

  def update_params
    params.require(:profile).permit(:bio, :availability, :skills, :name, :location)
  end
end
