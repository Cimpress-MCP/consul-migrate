require 'consul/migrate/version'
require 'consul/migrate/client'
require 'thor'

module Consul
  module Migrate
    class Cli < Thor

      attr_accessor :client

      desc 'version', 'Display consul-migrate version'
      def version
        say "#{VERSION}"
      end

      desc 'init', 'Initialize consul-migrate instance'
      option 'bind_client', type: :string, aliases: :c,
                            desc: 'HTTPS client to bind to'
      option 'port', type: :numeric, aliases: :p,
                     desc: 'Port to bind to'
      option 'acl_token', type: :string, aliases: :t,
                          desc: 'ACL token that is used to access API'
      def init
        @client = Consul::Migrate::Client.new(options)
      end
    end
  end
end
