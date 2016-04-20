module Wit
	require 'json'
	require 'curb'
	
	WIT_AI_URL = ENV['WIT_URL'] || 'https://api.wit.ai'
	class WitException < Exception
	end

	class Message
		attr_reader :response
		attr_accessor :body

		def initialize(body, access_token = '')
			@access_token = access_token
			@body = body
		end

		def send
			params = {}
			if @body
				params[:q] = @body.to_s
			end

			@response = request('message', params)
		end

		private

		def request(path, params)
			req_params = Curl::postalize(params)
			req = Curl::Easy.new("#{WIT_AI_URL}/#{path}?#{req_params}") do |http|
				http.follow_location = true
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