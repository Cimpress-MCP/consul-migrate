$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'consul/migrate'
require 'webmock/rspec'
require 'fakefs/safe'
require 'fakefs/spec_helpers'

WebMock.disable_net_connect!(allow_localhost: true)

SPEC_ROOT  = File.dirname(__FILE__)
JSON_FILE = File.expand_path("support/fixtures/acls.json", SPEC_ROOT)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /localhost:8500/).to_rack(ConsulStub)
  end
end
