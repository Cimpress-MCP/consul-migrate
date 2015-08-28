require 'spec_helper'

describe Consul::Migrate::Client do
  before do
    @client = Consul::Migrate::Client.new(acl_token: 'dummy-token')
  end

  it 'get_acls' do
    json_file = File.expand_path("support/fixtures/acls.json", SPEC_ROOT)
    @client.get_acls
    expect(@client).to_not eq File.read(json_file)
  end

  #Use FakeFS
  describe 'Importing and exporting ACLs' do
    include FakeFS::SpecHelpers
    it 'export_acls' do

      FakeFS::FileSystem.clone 'tmp'

      expect(false).to eq true
    end

    it 'import_acls' do

      expect(false).to eq true
    end
  end
end
