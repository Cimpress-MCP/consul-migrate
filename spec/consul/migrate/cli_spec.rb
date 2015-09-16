require 'spec_helper'

describe Consul::Migrate::Cli do
  include FakeFS::SpecHelpers

  before(:each) do
    FakeFS::FileSystem.clone SPEC_ROOT
    args = %w[init -t dummy-token]
    Consul::Migrate::Cli.start(args)
  end

  it 'should be able to init properly' do
    expect(File).to exist(File.join(Dir.home, '.cmigrate', 'init.conf'))
  end

  it 'should be able to export ACLs' do
    args = %w[export]
    expect(Consul::Migrate::Cli.start(args)).to eq(true)
    expect(File).to exist('output.json')
  end

  it 'should be able to import ACLs' do
    parsed_file_json = JSON.parse(File.read(JSON_FILE))

    json_array = []
    parsed_file_json.each do |e|
       json_array.push(e.select { |key, value| ['ID'].include?(key) })
    end

    FileUtils.cp(JSON_FILE, 'output.json')
    args = %w[import]
    expect(Consul::Migrate::Cli.start(args)).to match_array(json_array)
  end
end
