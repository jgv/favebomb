require 'oauth'
require 'optparse'
require 'pp'
require 'json'
require 'colored'

class Favebomb

  attr_accessor :results, :faved, :options

  def initialize(opts={})
    @options = {
      :lang => nil,
      :type => nil,
      :count => nil,
      :until => nil,
      :geocode => nil
    }
    @faved = []
    @client = prepare_access_token(ENV["FAVEBOMB_ACCESS_TOKEN"], ENV["FAVEBOMB_ACCESS_SECRET"])
  end

  def bomb term
    parse_options!
    puts "looking for #{term}".bold.blue
    query = generate_params term

    search = @client.request(:get, "http://api.twitter.com/1.1/search/tweets.json?#{query}")
    @results = JSON.parse(search.read_body)["statuses"]
    puts "found #{@results.count} tweets"
    results.each {|tweet| fave! tweet if tweet["favorited"] == false }
    puts
    puts "faved #{@faved.count} tweets"
  end

  private

  def parse_options!
    OptionParser.new do |opts|
      opts.banner = "Usage: favebomb [command] [options]"
      opts.on("-l", "--lang lang", "Restricts tweets to the given language, given by an ISO 639-1 code. Language detection is best-effort.") {|lang| @options[:lang] = lang }
      opts.on("-t", "--type type", "Restrict tweets to a specific type. Choose between popular, recent, or mixed (the default).") {|type| @options[:type] = type }
      opts.on("-c", "--count count", "Control the number of tweets to fave. Maximum is 100, default is 15.") {|count| @options[:count] = count }
      opts.on("-u", "--until date", "Returns tweets generated before the given date. Date should be formatted as YYYY-MM-DD. Keep in mind that the search index may not go back as far as the date you specify here.") {|date| @options[:until] = date }
      opts.on("-g", "--geocode code", "Returns tweets by users located within a given radius of the given latitude/longitude. The location is preferentially taking from the Geotagging API, but will fall back to their Twitter profile. The parameter value is specified by 'latitude,longitude,radius', where radius units must be specified as either 'mi' (miles) or 'km' (kilometers). Note that you cannot use the near operator via the API to geocode arbitrary locations; however you can use this geocode parameter to search near geocodes directly. A maximum of 1,000 distinct 'sub-regions' will be considered when using the radius modifier.") {|code|
        @options[:geocode] = code }
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        Kernel.exit!
      end
    end.parse!
  end

  def generate_params term
    params = ""
    @options.each {|k,v| params += "&#{k}=#{URI.encode(v)}" if v != nil }
    query = "q=#{URI.encode(term)}" + params
    return query
  end

  def fave! tweet
    puts
    puts "faving..".yellow
    puts tweet["text"]
    fave = @client.request(:post, "https://api.twitter.com/1.1/favorites/create.json?id=#{tweet["id"]}")
    if fave.response.code.to_i == 200
      puts "faved!".bold.green
      @faved << tweet
    else
      begin
        json = JSON.parse(fave.read_body)["errors"]
        puts json ["errors"]["message"].bold.red if json["errors"]
      rescue Exception => e
        puts "Error: ".bold.red + e.to_s.bold.red
      end
    end
  end

  def prepare_access_token oauth_token, oauth_token_secret
    consumer = OAuth::Consumer.new(ENV["FAVEBOMB_CONSUMER_KEY"], ENV["FAVEBOMB_CONSUMER_SECRET"],
      { :site => "http://api.twitter.com",
        :scheme => :header
      })

    token_hash = {
      :oauth_token => oauth_token,
      :oauth_token_secret => oauth_token_secret
    }

    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    return access_token
  end

end
