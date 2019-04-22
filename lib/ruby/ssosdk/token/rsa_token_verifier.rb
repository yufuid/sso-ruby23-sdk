module Ssosdk
  require 'jwt'
  require 'openssl'
  class RSATokenVerifier
    def initialize(publicKeyInfo)
      @publicKey = OpenSSL::PKey::RSA.new File.read publicKeyInfo
    end

    def verify(token)
        payload, header = JWT.decode token, @publicKey, true, {:verify_expiration => true, :verify_not_before => true, :verify_iat => true, :algorithm => 'RS256'}
        [payload, header]
    end
  end
end
