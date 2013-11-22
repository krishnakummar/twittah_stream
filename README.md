#### twittah_stream

Hello!  This is a throwaway app to play with Rails 4 + Twitter's streaming API

#### setup

Just add a file ./config/initializers/twitter.rb that contains something like:

```
  TWITTER_CLIENT = Twitter::Streaming::Client.new do |config|
    config.consumer_key        = "xxx"
    config.consumer_secret     = "xxx"
    config.access_token        = "xxx"
    config.access_token_secret = "xxx"
  end
```

Add your credentials, register for an application to get credentials at Twitter's API pages.

A real app will probably want a more robust solution than a global constant client.
