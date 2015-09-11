require 'consul/migrate/version'
require 'consul/migrate/client'
require 'thor'
require 'yaml'
require 'fileutils'

module Consul
  module Migrate
    class Cli < Thor

      attr_accessor :client

      def initialize(*args)
        super
        read_config
      end

      desc 'version', 'Display consul-migrate version'
      def version
        say "#{VERSION}"
      end

      desc 'init', 'Initialize consul-migrate instance'
      method_option :bind_client, type: :string, aliases: :c,
                           desc: 'HTTPS client to bind to'
      method_option :port, type: :numeric, aliases: :p,
                    desc: 'Port to bind to'
      method_option :acl_token, type: :string, aliases: :t,
                         desc: 'ACL token that is used to access API'
      def init
        write_config(options)
      end

      desc 'export', 'Export ACLs from Consul via agent running in this system'
      option :file, type: :string, default: 'output.json', aliases: :f,
                     desc: 'Target file to write to'
      def export
        puts @client.options
        @client.export_acls(options[:file])
      end

      desc 'import', 'Import ACLs into Consul cluster via agent running in this system'
      option :file, type: :string, default: 'output.json', aliases: :f,
                     desc: 'Target file to read from'
      def import
        @client.import_acls(options[:file])
      end

      private

      CONFIG_FILE = File.expand_path('~/.cmigrate/init.conf')

      def write_config(options)
        parent_dir = File.dirname(CONFIG_FILE)
        FileUtils.mkdir_p parent_dir

        client = Consul::Migrate::Client.new(options)
        new_options = client.options

        File.open(CONFIG_FILE, 'w') do |f|
          # Convert keys from symbols to string and turn hash into YAML
          f.write Hash[new_options.map{|(k,v)| [k.to_s,v]}].to_yaml
        end
      end

      def read_config
        return unless File.exists?(CONFIG_FILE)

        config = YAML.load_file(CONFIG_FILE)
        @client = Consul::Migrate::Client.new(config)
      end
    end
  end
end
