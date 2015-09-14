require 'json'
require 'net/http'
require 'consul/migrate/defaults'
require 'consul/migrate/error'

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

      # GET /v1/acl/list
      def get_acl_list
        uri = URI("#{base_url}/v1/acl/list")
        uri.query = URI.encode_www_form(http_params)
        response = Net::HTTP.get_response(uri)

        if !response.kind_of? Net::HTTPSuccess
          fail Error, response.body
        end

        response.body
      end

      # PUT /v1/acl/create
      def put_acl(acl_hash)
        uri = URI("#{base_url}/v1/acl/create")
        uri.query = URI.encode_www_form(http_params)
        req = Net::HTTP::Put.new(uri)
        req.body = acl_hash.to_json

        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end

        if !response.kind_of? Net::HTTPSuccess
          fail Error, response.body
        end

        response.body
      end

      # Export ACLs into a file
      def export_acls(dest)
        json = get_acl_list

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
          h = JSON.parse(put_acl(k))
          result.push(h)
        end

        return result
      end

      private

      # Parse valid options
      def parse_options(options)
        defaults = DEFAULTS.dup
        options = options.dup

        valid_options = {}

        # Use default when option is not specified or nil
        defaults.keys.each do |key|
          valid_options[key] = defaults[key] if options[key].nil?

        end

        valid_options
      end
    end
  end
end
