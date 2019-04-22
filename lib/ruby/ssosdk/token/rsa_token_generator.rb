module Ssosdk
  class RSATokenGenerator

    def initialize(privateKeyPath, issuer, tenant, keyFingerPrint)
      @issuer = issuer
      @tenant = tenant
      @keyId = keyFingerPrint == nil ? issuer : issuer + YufuTokenConstants::KEY_ID_SEPARATOR + keyFingerPrint
      if privateKeyPath.nil?
        raise "key filename cannot be blank"
      end
      #读取私钥
      @rsa_private = OpenSSL::PKey::RSA.new(File.read(privateKeyPath))
    end


    def generate(claims)
      audience = claims["aud"]
      if audience.nil?
        audience = YufuTokenConstants::AUDIENCE_YUFU
      end
      iat = Time.now.to_i
      exp = Time.now.to_i + YufuTokenConstants::TOKEN_EXPIRE_TIME_IN_MS
      payload = {:aud => audience, :exp => exp, :iat => iat, :iss => @issuer, :tnt => @tenant}
      payload=payload.merge(claims)
      JWT.encode payload, @rsa_private, 'RS256', {keyId: @keyId, :type => "JWT"}
    end

    def generate_idp_redirect_url(claims)
      Ssosdk::YufuTokenConstants.IDP_TOKEN_CONSUME_URL + "?idp_token=" + generate(claims)
    end
  end
end
