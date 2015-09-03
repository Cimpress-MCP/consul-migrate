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
        response = Net::HTTP.get_response(URI.parse(url))

        return response
      end

      # PUT single ACL
      def put_acl(acl_hash)
        uri = URI("http://localhost:8500/v1/acl/create?token=#{@@acl_token}")
        req = Net::HTTP::Put.new(uri)
        req.body = acl_hash.to_json

        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end

        return response
      end

      # Export ACLs into a file
      def export_acls(dest)
        json = get_acl_list.body

        File.open(dest, 'w') { |file|
          file.write(json)
        }
      end

      # Import ACLs from a file
      # Returns array of IDs that were inserted into consul's ACL
      def import_acls(file)
        f = File.read(file)
        data_hash = JSON.parse(f)

        result = []
        data_hash.each do |k, v|
          h = JSON.parse(put_acl(k).body)
          result.push(h)
        end

        return result
      end

    end
  end
end
