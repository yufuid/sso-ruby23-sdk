module Ssosdk
  require_relative '../../../lib/ruby/ssosdk/token/rsa_token_generator'
  require_relative '../../../lib/ruby/ssosdk/token/rsa_token_verifier'
  class YufuAuth

    @tokenVerifier
    @tokenGenerator
    def initialize_verifier(keyPath)
      @tokenVerifier=Ssosdk::RSATokenVerifier.new(keyPath)
    end

    def initialize_generator(keyPath, issuer, tenantId, keyFingerPrint=nil )
      if keyPath.nil?
        raise("private key must be set")
      end
      @tokenGenerator = Ssosdk::RSATokenGenerator.new(keyPath, issuer, tenantId, keyFingerPrint)
      @tenantId=tenantId
    end

    def generate_token(claims)
      token=@tokenGenerator.generate(claims)
      token
    end

    def generate_idp_redirect_url(claims)
      Ssosdk::YufuTokenConstants::IDP_TOKEN_CONSUME_URL + "?idp_token=" + generate_token(claims)
    end

    def verify_token(token)
      payload, header=@tokenVerifier.verify(token)
      [payload, header]
    end
  end
end