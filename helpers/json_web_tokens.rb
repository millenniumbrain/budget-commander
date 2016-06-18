=begin
In order to secure the application from untrusted clients we will use **JSON Web Tokens**
using this method we can generate nice encoded urls, track the audience(clients/users)
and verify client access with the server
=end

# TODO: switch to HMAC for web client
# TODO: remove sessions store tokens in local storage
module JsonWebToken
  module ResponseMethods
    # return regular payload if the session token is not set
    def payload
      @payload if session[:encoded_token].nil?
    end

    def encode_payload(payload)
      @payload = payload
    end

    def decoded_token
      # convert the public key back into an PKey object
      rsa_public_key = OpenSSL::PKey::RSA.new(session[:public_key]).public_key
      # make sure that the public key is verified before decoding
      decode_token = JWT.decode(session[:encoded_token], rsa_public_key, true, { :algorithm => 'RS256' })
    end

    # TODO: allow for other signing methods
    def encode_token
      rsa_private_key = OpenSSL::PKey::RSA.generate(2048)
      rsa_public_key = rsa_private_key.public_key
      # sessions do not store objects so we convert the public key to a string
      session[:public_key] = rsa_public_key.to_s
      session[:encoded_token] = JWT.encode(@payload, rsa_private_key, 'RS256')
    end

    # certain instances require the use of the header.payload.signature
    # like a sign up link in an email or and auth token for a form
    def encoded_token
      if session[:encoded_token].nil?
        "a token has not been genereated"
      else
        session[:encoded_token]
      end
    end

    # clear sessions
    def clear_token
      session[:public_key] = nil
      session[:encoded_token] = nil
    end
  end
end
