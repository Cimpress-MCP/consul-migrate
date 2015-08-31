require 'spec_helper'

describe Consul::Migrate::Client do
  include FakeFS::SpecHelpers

  before do
    @client = Consul::Migrate::Client.new(acl_token: 'dummy-token')
    FakeFS::FileSystem.clone SPEC_ROOT
  end

  it 'get_acl_list' do
    json_file = File.expand_path("support/fixtures/acls.json", SPEC_ROOT)
    @client.get_acl_list
    expect(@client).to_not eq File.read(json_file)
  end

  it 'put_acl' do
    data_hash = {
      :CreateIndex => 1,
      :ModifyIndex => 2,
      :ID => '8f246b77-f3e1-ff88-5b48-8ec93abf3e05',
      :Name => 'Client Token',
      :Type => 'client',
      :Rules => ''
    }

    expect(@client.put_acl(data_hash)).to eq "200"
  end

  describe 'importing and exporting ACLs' do
    it 'export_acls' do
      @client.export_acls('tmp')
      File.read('tmp')
      expect(File.exist?('tmp')).to eq true

    end

    it 'import_acls' do

      expect(false).to eq true
    end
  end
end
