require 'rubygems' # may not be needed
require 'openssl'
require 'digest/sha1'
require 'net/https'
require 'base64'

class CloudfrontInvalidator

  def initialize(aws_account, aws_secret, distribution)
    @aws_account  = aws_account
    @aws_secret   = aws_secret
    @distribution = distribution
  end

  def invalidate(paths)
    date   = Time.now.strftime("%a, %d %b %Y %H:%M:%S %Z")
    digest = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), @aws_secret, date)).strip
    uri    = URI.parse("https://cloudfront.amazonaws.com/2012-05-05/distribution/#{@distribution}/invalidation")

    req = Net::HTTP::Post.new(uri.path)
    req.initialize_http_header({
      'Date'          => date,
      'Content-Type'  => 'text/xml',
      'Authorization' => "AWS %s:%s" % [@aws_account, digest]
    })
    req.body = %|
      <InvalidationBatch xmlns="http://cloudfront.amazonaws.com/doc/2012-05-05/">
        <Paths>
            <Quantity>#{paths.size}</Quantity>
            <Items>
              #{paths.map{|p| '<Path>'+ p +'</Path>'}.join("\n    ")}
            </Items>
          </Paths>

        <CallerReference>#{Time.now.utc.to_i}</CallerReference>
      </InvalidationBatch>
    |

    puts req.body

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = http.request(req)

    # it was successful if response code was a 201
    puts res.code
    puts res.body
  end
end