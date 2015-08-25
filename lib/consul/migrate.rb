require 'consul/migrate/version'
require 'json'
require 'net/http'

module Consul
  module Migrate
    def get_acls(token)
      base_url = "http://localhost:8500/v1/acl/list"
      url = "#{base_url}?pretty=true&token=#{token}"
      resp = Net::HTTP.get_response(URI.parse(url))
      data = resp.body

      result = JSON.parse(data)

      return result
    end
  end
end
