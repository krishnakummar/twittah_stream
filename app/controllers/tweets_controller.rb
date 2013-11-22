require 'reloader/sse'

class TweetsController < ApplicationController
  include ActionController::Live

  before_filter :setup_streaming

  def index
    latitude, longitude = params[:latlng].split(',')
    radius              = params[:radius]

    bbox = Geocoder::Calculations.bounding_box([latitude, longitude], radius)

    begin
      TWITTER_CLIENT.filter({locations: [bbox[1], bbox[0], bbox[3], bbox[2]].join(',')}) do |tweet|
        parsed_tweet = ParsedTweet.new(tweet.attrs)
        @sse.write({ tweet: parsed_tweet.attributes }.to_json, event: "refresh") if parsed_tweet.valid?
      end
    rescue IOError
    ensure
      @sse.close
    end
  end

  private

  def setup_streaming
    response.headers['Content-Type'] = 'text/event-stream'
    @sse  = Reloader::SSE.new(response.stream)
  end
end
