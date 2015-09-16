module Consul
  module Migrate
    CLIENT_DEFAULTS = {
      :bind_client => 'localhost',
      :port        => 8500
    }
  end

  CONFIG_FILE = File.join(Dir.home, '.cmigrate/init.conf')
end
