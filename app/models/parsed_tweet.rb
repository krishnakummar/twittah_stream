class ParsedTweet
  attr_accessor :twitter_id, :twitter_created_at, :media_url, :large_url, :thumbnail_url, :latitude, :longitude, :description, :user, :attributes

  def initialize(attrs)
    @attributes = extract_attributes_from_twitter(attrs)
    @attributes.each { |name, value| self.send("#{name}=", value) }
  end

  def valid?
    (!latitude.nil?  && latitude  != "") &&
    (!longitude.nil? && longitude != "") &&
    (!media_url.nil? && media_url != "")
  end

  def extract_attributes_from_twitter(attrs)
    latitude, longitude = parse_coordinates(attrs)
    entities = attrs[:entities]
    media_url = retrieve_media_url(entities)

    {
      twitter_id:         attrs[:id].to_s,
      twitter_created_at: twitter_timestamp(attrs[:created_at]),
      media_url:          media_url,
      large_url:          set_large_url(media_url),
      latitude:           latitude,
      longitude:          longitude,
      description:        attrs[:text],
      user:               attrs[:user][:screen_name]
    }
  end

  private

  def parse_coordinates(attrs)
    if attrs && attrs[:geo]
      [ attrs[:geo][:coordinates][0], attrs[:geo][:coordinates][1] ]
    elsif attrs && attrs[:coordinates]
      [ attrs[:coordinates][:coordinates][1], attrs[:coordinates][:coordinates][0] ]
    end
  end

  def retrieve_media_url(entities)
    return if entities.nil?

    if entities[:media]
      entities[:media][0][:media_url]
    elsif entities[:urls]
      retrieve_first_valid_url_match(entities[:urls])
    end
  end

  def retrieve_first_valid_url_match(urls)
    u = urls.find { |url| url[:expanded_url] =~ /instagram.com/ }
    if u
      u[:expanded_url]
    end
  end

  def set_large_url(media_url)
    if media_url =~ /instagram.com/
      "#{media_url}media?size=l"
    else
      "#{media_url}:large"
    end
  end

  def twitter_timestamp(created_at)
    Time.parse(created_at).utc.strftime('%FT%TZ')
  rescue
    nil
  end
end
