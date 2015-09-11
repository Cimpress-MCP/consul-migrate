require 'json'
require 'net/http'
require 'consul/migrate/defaults'

module Consul
  module Migrate
    class Client
      # Make options readable to CLI
      attr_reader :options

      def bind_client; @options[:bind_client]; end
      def port;        @options[:port];        end

      def base_url
        "http://#{bind_client}:#{port}"
      end

      def http_params
        { :token => @options[:acl_token] }
      end

      def initialize(options = {})
        @options = parse_options(options)
      end

      # Get all ACLs
      def get_acl_list

        uri = URI("#{base_url}/v1/acl/list")
        uri.query = URI.encode_www_form(http_params)
        response = Net::HTTP.get_response(uri)

        return response
      end

      # PUT single ACL
      def put_acl(acl_hash)
        uri = URI("#{base_url}/v1/acl/create")
        uri.query = URI.encode_www_form(http_params)
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

      private

      # Method to fill in with default values if no options provided
      def parse_options(options)
        defaults = DEFAULTS.dup
        options = options.dup


        # Use default when option is not specified or nil
        defaults.keys.each do |key|
          options[key] = defaults[key] if options[key].nil?

          # Symbolize only keys that are needed
          options[key] = options[key.to_s] if options.has_key?(key.to_s)
        end

        options
      end
    end
  end
end
