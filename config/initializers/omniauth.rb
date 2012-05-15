Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           :scope => 'email,offline_access,read_stream', :display => 'popup'
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :google, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
  provider :developer unless Rails.env.production?
end
