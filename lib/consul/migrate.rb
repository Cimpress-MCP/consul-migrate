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

        # TODO: Validate JSON

        return resp.body
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
        json = get_acl_list

        File.open(dest, 'w') { |file|
          file.write(json)
        }
      end

      # Import ACLs from a file
      def import_acls(file)
        f = File.read(file)
        data_hash = JSON.parse(f)

        result = []
        data_hash.each do |k, v|
          # result.push(put_acl(k))
          # put_acl(k)
        end

        # puts result
        return result
      end

    end
  end
end
