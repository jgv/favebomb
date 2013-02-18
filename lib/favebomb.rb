require 'oauth'
require 'json'

class Favebomb

  attr_accessor :results

  def initialize
    @client = prepare_access_token(ENV["FAVEBOMB_ACCESS_TOKEN"], ENV["FAVEBOMB_ACCESS_SECRET"])
    @faved = []
    if @client
      bomb ARGV[0]
    else
      puts "Can't connect to Twitter"
    end
  end

  def bomb term
    puts "looking for #{term}"
    search = @client.request(:get, "http://api.twitter.com/1.1/search/tweets.json?q=#{URI.encode(term)}")
    @results = JSON.parse(search.read_body)["statuses"]
    puts "found #{@results.count} tweets"
    results.each {|tweet| fave tweet if tweet["favorited"] == false }
    puts "faved #{@faved.count} tweets"
  end

  private

  def fave tweet
    puts
    puts "faving.."
    puts tweet["text"]
    fave = @client.request(:post, "https://api.twitter.com/1.1/favorites/create.json?id=#{tweet["id"]}")
    if fave.response.code.to_i == 200
      puts "faved!"
      @faved << tweet
    else
      begin
        json = JSON.parse(fave.read_body)["errors"]
        puts json ["errors"]["message"] if json["errors"]
      rescue Exception => e
        puts e
      end
    end
    return fave
  end

  def prepare_access_token oauth_token, oauth_token_secret
    consumer = OAuth::Consumer.new(ENV["FAVEBOMB_CONSUMER_KEY"], ENV["FAVEBOMB_CONSUMER_SECRET"],
      { :site => "http://api.twitter.com",
        :scheme => :header
      })

    # now create the access token object from passed values
    token_hash = {
      :oauth_token => oauth_token,
      :oauth_token_secret => oauth_token_secret
    }

    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    return access_token
  end

end
