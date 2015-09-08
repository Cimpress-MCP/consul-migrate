require 'consul/migrate/client'
require 'consul/migrate/version'

module Consul
  module Migrate
    class << self

      # Delegate to Consul::Migrate::Client
      def client(options={})
        Consul::Migrate::Client.new(options)
      end
    end
  end
end
