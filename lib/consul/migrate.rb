require 'consul/migrate/version'
require 'json'
require 'net/http'

module Consul
  module Migrate
    class Client
      def initialize(args = {})
        if args[:acl_token]
          @@acl_token = args[:acl_token]
        else
          @@acl_token = ENV['acl_token']
        end
      end

      def get_acls
        base_url = "http://localhost:8500/v1/acl/list"
        url = "#{base_url}?token=#{@@acl_token}"
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body

        result = JSON.parse(data)

        return result
      end

      def export_acls(dest)
        json = get_acls

        File.open(dest, 'w') { |file|
          file.write(json)
        }
      end

      def import_acls(from_dir)
        
      end
    end
  end
end
