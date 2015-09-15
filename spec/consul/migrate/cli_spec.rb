require 'spec_helper'

describe Consul::Migrate::Cli do
  include FakeFS::SpecHelpers

  before do
    FakeFS::FileSystem.clone SPEC_ROOT
    subject.options = { :acl_token => 'dummy-token' }
    subject.init
  end

  it 'should be able to init properly' do
    expect(File).to exist(File.join(Dir.home, '.cmigrate', 'init.conf'))
  end

  it 'should be able to export ACLs' do
    expect(subject.export).to_not raise_error
  end

  it 'should be able to import ACLs' do
    expect(subject.import).to_not raise_error
  end

end
