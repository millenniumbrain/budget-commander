module Wit
  require 'json'
  require 'curb'
  require 'pp'
  class WitException < Exception
  end

  class AI
    attr_reader :message

    WIT_URI = ENV['WIT_URL'] || 'https://api.wit.ai'
    def initialize(access_token,  message)
      @access_token = access_token
      @message = message
    end

    def message
     params = {}
     if @message
       params[:v] = "20160405".freeze
       params[:q] = @message.to_s
     end

     request('/message', params)
    end

    private

    def request(path, params)
      req_params = Curl::postalize(params)
      req = Curl::Easy.new(WIT_URI + path + "?#{req_params}") do |http|
        http.headers['Authorization'] = "Bearer #{@access_token}"
      end
      req.perform
      if req.response_code > 200
        raise WitException.new("Error Wit AI returned #{req.response_code} code")
      end
      JSON.parse(req.body_str)
    end

    def multi_req(url)
    end
    
  end
end

my_message = "last month -$1240.34 desc Birthday Party tags gifts, friends, fun, entertainment to Checkings"
message = Wit::AI.new("TXKZPZIXMVWWV7XLC64DRUW52UAOY4M6", my_message)
pp message.message
