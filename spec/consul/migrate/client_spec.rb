require 'spec_helper'

describe Consul::Migrate::Client do
  include FakeFS::SpecHelpers

  before do
    @client = Consul::Migrate::Client.new(acl_token: 'dummy-token')
    FakeFS::FileSystem.clone SPEC_ROOT
  end

  context 'class methods' do
    it '.get_acl_list' do
      json_file = File.expand_path("support/fixtures/acls.json", SPEC_ROOT)
      @client.get_acl_list
      expect(@client).to_not eq File.read(json_file)
    end

    it '.put_acl' do
      data_hash = {
        :CreateIndex => 1,
        :ModifyIndex => 2,
        :ID => '8f246b77-f3e1-ff88-5b48-8ec93abf3e05',
        :Name => 'Client Token',
        :Type => 'client',
        :Rules => ''
      }

      expect(@client.put_acl(data_hash).code).to eq "200"
    end

    it '.export_acls' do
      @client.export_acls('tmp.json')

      parsed_data = JSON.parse(File.read('tmp.json'))
      json_file = File.expand_path("support/fixtures/acls.json", SPEC_ROOT)
      parsed_json_file = JSON.parse(File.read(json_file))

      expect(File.exist?('tmp.json')).to eq true
      expect(parsed_data).to eq parsed_json_file
    end

    it '.import_acls' do
      json_file = File.expand_path("support/fixtures/acls.json", SPEC_ROOT)
      parsed_json_file = JSON.parse(File.read(json_file))

      expected = []
      parsed_json_file.each do |e|
         expected.push(e.select {|key, value| ['ID'].include?(key) })
      end

      r = @client.import_acls(json_file)

      expect(r).to match_array(expected)
    end
  end
end
