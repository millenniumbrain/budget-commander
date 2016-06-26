=begin
In order to secure the application from untrusted clients we will use **JSON Web Tokens**
using this method we can generate nice encoded urls, track the audience(clients/users)
and verify client access with the server
=end

# TODO: switch to HMAC for web client
# TODO: remove sessions store tokens in local storage
module JsonWebToken
  module ResponseMethods

    def token
      return @token unless @token.nil?
    end

    def encode_payload(payload)
      @token = generate_token(payload)
    end

    def decode_token(token)
      JWT.decode(token, ENV['HMAC-SECRET'], true, { algorithm: 'HS256' })
    end

    def clear_login
      session[:encoded_token] = nil
    end

    private
    # TODO: allow for other signing methods
    def generate_token(payload)
      JWT.encode(payload, ENV['HMAC-SECRET'], 'HS256')
    end
  end
end
