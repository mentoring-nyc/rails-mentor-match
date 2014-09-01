Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get  'signup/benefits'         => 'signup#benefits',                    as: 'signup_benefits'
  get  'signup/complete-profile' => 'signup#complete_profile',            as: 'signup_complete_profile'
  post 'signup/complete-profile' => 'signup#complete_profile_submission', as: 'signup_complete_profile_submission'
  get  'signup/success'          => 'signup#success',                     as: 'signup_success'
  get  'signup/:role'            => 'signup#define_role',                 as: 'signup_define_role'
  get  'auth/github'             => 'o_auth#github',                      as: 'oauth_github'
  get  'auth/github/callback'    => 'o_auth#github_callback',             as: 'oauth_github_callback'

  root to: 'signup#welcome'
end
