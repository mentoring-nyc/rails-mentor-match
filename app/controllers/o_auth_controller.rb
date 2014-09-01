class OAuthController < ApplicationController
  CONTENT_TYPE          = 'application/json'
  GITHUB_URL            = 'https://github.com'
  GITHUB_OAUTH_CALLBACK = "#{ENV['DOMAIN']}/auth/github/callback"
  GITHUB_AUTHORIZE_URL  = "#{GITHUB_URL}/login/oauth/authorize"
  GITHUB_TOKEN_URL      = '/login/oauth/access_token'

  def github
    session['auth.redirect_uri'] = params[:redirect_uri] || '/'
    segments = {}
    segments['client_id'] = ENV['GITHUB_KEY']
    segments['redirect_uri'] = GITHUB_OAUTH_CALLBACK
    segments['scope'] = 'user:email,public_repo,gist,read:public_key'
    segments['state'] = session['auth.state'] = SecureRandom.base64(32)
    query = segments.map{ |k,v| "#{k}=#{v}" }.join('&')

    redirect_to "#{GITHUB_AUTHORIZE_URL}?#{query}"
  end

  def github_callback
    if params[:state].gsub(' ', '+') == session['auth.state']
      response = connection(GITHUB_URL).get do |request|
        request.url GITHUB_TOKEN_URL
        request.headers['Accept']       = CONTENT_TYPE
        request.params['client_id']     = ENV['GITHUB_KEY']
        request.params['client_secret'] = ENV['GITHUB_SECRET']
        request.params['code']          = params[:code]
        request.params['redirect_uri']  = GITHUB_OAUTH_CALLBACK
      end

      client = Octokit::Client.new(access_token: response.body['access_token'])

      user = User.find_with_oauth({
        'provider' => :github, 'uid' => client.user.id,
        credentials: {
          token: response.body['access_token']
        },
        info: {
          nickname: client.user.login,
          email: client.emails.detect {|e| e[:primary] }[:email],
          name: client.user.name,
          image: client.user.avatar_url,
          location: client.user.location
        }
      })

      session['auth.entity_id'] = user.id
      redirect_to session['auth.redirect_uri']
    else
      halt 403, 'state not authentic'
    end
  end

  def connection(url)
    Faraday.new(url: url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.response :json, :content_type => /\json$/
      faraday.adapter  Faraday.default_adapter
    end
  end
end
