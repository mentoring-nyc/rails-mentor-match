# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_MentoringNyc_session'
Rails.application.config.session_store :redis_store, redis_server: ENV['REDISCLOUD_URL']
