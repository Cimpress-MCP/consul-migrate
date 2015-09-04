require 'consul/migrate/version'
require 'json'
require 'net/http'

module Consul
  module Migrate
    class Client
      attr_reader :options

      def bind_client; options[:bind_client]; end
      def port;        options[:port];        end
      def acl_token;   options[:acl_token];   end
      def base_url;    "http://#{bind_client}:#{port}"; end

      def initialize(options = {})
        @options = {
          :bind_client => 'localhost',
          :port        => 8500
        }.merge(options)
      end

      # Get all ACLs
      def get_acl_list
        url = "#{base_url}/v1/acl/list?token=#{acl_token}"
        response = Net::HTTP.get_response(URI.parse(url))

        return response
      end

      # PUT single ACL
      def put_acl(acl_hash)
        uri = URI("#{base_url}/v1/acl/create?token=#{acl_token}")
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

        return true
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
