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

      # Get all ACLs
      def get_acl_list
        base_url = "http://localhost:8500/v1/acl/list"
        url = "#{base_url}?token=#{@@acl_token}"
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body

        result = JSON.parse(data)

        return result
      end

      # PUT single ACL
      def put_acl(acl_hash)
        uri = URI("http://localhost:8500/v1/acl/create?token=#{@@acl_token}")
        req = Net::HTTP::Put.new(uri)
        req.body = acl_hash.to_json

        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end

        return response.code
      end

      # Export ACLs into a file
      def export_acls(dest)
        json = get_acl_list

        File.open(dest, 'w') { |file|
          file.write(json)
        }
      end

      # Import ACLs from a file
      def import_acls(json_file)
        file = File.read(json_file)
        data_hash = JSON.parse(file)

        data_hash.each do |k, v|
          puts v
        end
      end

    end
  end
end
