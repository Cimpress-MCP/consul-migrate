$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'consul/migrate'
require 'webmock/rspec'
require 'support/consul_stub'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /localhost:8500/).to_rack(ConsulStub)
  end
end
