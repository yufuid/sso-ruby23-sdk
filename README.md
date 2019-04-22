## 玉符单点登录 SDK

玉符SDK集成了签署和验证JWT令牌的功能，使得身份提供者（IDP）和服务提供者（SP）只需要用很少的工作量就可以快速将玉符提供的单点登录等功能集成到现有的服务中。

## 单点登录SDK简介
作为服务提供者（SP）,可以使用玉符SDK验证JWT令牌的有效性（包括有效期、签名等），验证成功后可取出token中字段进行相应的鉴权。
作为身份提供者（IDP）,可以使用玉符SDK灵活进行参数配置，并生成带有token的跳转url，进行单点登录功能。

## 安装
Add this line to your application's Gemfile:

```ruby
gem 'ruby-sso-sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    gem "ruby-sso-sdk", :git => "git://github.com/306994914/ruby-sso-sdk.git"


## SDK使用
1.服务提供者(SP)
使用必要信息初始化SDK
```ruby
    @yufuAuth = Ssosdk::YufuAuth.new
    @yufuAuth.initializeVerifier(keyPath)
    jwt = @yufuAuth.verifyToken(testToken)
```
## 身份提供者（IDP)

1.自定义jwt的参数
```ruby
    claims = {Ssosdk::YufuTokenConstants::APP_INSTANCE_ID_KEY => "testAppInstanceId", "customFieldsKey" =>              "customFieldsValue"}
```  
2.使用必要信息初始化SDK（必要参数在玉符初始化后获取）
```ruby
    @yufuAuth = Ssosdk::YufuAuth.new
    @yufuAuth.initializeGenerator(keyPath, "testIssuer", "testTenant", "2bf935821aa33e693d39ab569ba557aa0af8e02e")
    idp_token = @yufuAuth.generateToken(claims)
    jwt = JWT.decode idp_token, nil, false
    puts @yufuAuth.generateIDPRedirectUrl(claims)
```    
