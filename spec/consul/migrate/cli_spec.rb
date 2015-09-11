require 'spec_helper'

describe Consul::Migrate::Cli do
  include FakeFS::SpecHelpers

  before do
    FakeFS::FileSystem.clone SPEC_ROOT
  end

  context 'export ACLs' do
    pending
    # it 'should be able to export ACLs' do
    #   subject.options = { :acl_token => 'dummy-token' }
    #   subject.init
    #   subject.export
    #
    #   expect(File).to exist(File.expand_path('output.json'))
    # end
  end

  context 'importing ACLs' do
    pending
  end

end
