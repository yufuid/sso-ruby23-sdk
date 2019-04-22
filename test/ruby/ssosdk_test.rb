require 'minitest/autorun'
require 'pathname'
require_relative '../../lib/ruby/ssosdk/yufu_auth'
require_relative '../../lib/ruby/ssosdk/constants/yufu_token_constants'
class SsosdkTest < Minitest::Test
  def setup
    @path = Pathname.new(File.dirname(__FILE__)).realpath
  end

  def test_verify_token

    keyPath = "#{@path}/testPublicKey.pem"
    testToken = "eyJraWQiOiJ0ZXN0a2V5aWQiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJ0ZXN0Iiwic3ViIjoidGVzdEB5dWZ1LmNvbSIsInN0eXBlIjoiZW1haWwiLCJpc3MiOiJ5dWZ1IiwidG50IjoiMjk3MjIwIiwiZXhwIjo5OTUzODcxMzY3NywiaWF0IjoxNTI4NzEzMDc3fQ.cSy7Wye3Gl03tu96fpypXJ_WQa0HTMeMgfdzzfFHhHluuak7YdxnYpuybhjyA4pi4HdJRVeermRIuh4e72dpQGkAcX9jem_WKBNCUgFoO7iTGhhb0G4wfv-G0gfE4AKTmdVBWi8SB5JkhTCWZVFkl-kzWUFGDurod2DD-LljBaQ"
    @yufuAuth = Ssosdk::YufuAuth.new
    @yufuAuth.initialize_verifier(keyPath)
    jwt = @yufuAuth.verify_token(testToken)
    payload = jwt[0]
    assert_equal "yufu", payload['iss']
    assert_equal "test@yufu.com", payload['sub']
    assert_equal "297220", payload['tnt']
  end

  def test_generate_token
    keyPath = "#{@path}/testPrivateKey.pem"
    claims = {Ssosdk::YufuTokenConstants::APP_INSTANCE_ID_KEY => "testAppInstanceId", "customFieldsKey" => "customFieldsValue"}
    @yufuAuth = Ssosdk::YufuAuth.new
    @yufuAuth.initialize_generator(keyPath, "testIssuer", "testTenant", "2bf935821aa33e693d39ab569ba557aa0af8e02e")
    idp_token = @yufuAuth.generate_token(claims)
    jwt = JWT.decode idp_token, nil, false
    puts @yufuAuth.generate_idp_redirect_url(claims)
    header = jwt[1]
    assert_equal "testIssuer###2bf935821aa33e693d39ab569ba557aa0af8e02e", header["keyId"]
    payload = jwt[0]
    assert_equal "testAppInstanceId", payload[Ssosdk::YufuTokenConstants::APP_INSTANCE_ID_KEY]
    assert_equal "testIssuer", payload["iss"]
    assert_equal "testTenant", payload["tnt"]
  end
end
