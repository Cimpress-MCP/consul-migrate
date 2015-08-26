require 'spec_helper'

describe Consul::Migrate do
  it 'has a version number' do
    expect(Consul::Migrate::VERSION).not_to be nil
  end

  it 'should return a non-empty response' do
    uri = URI('http://localhost:8500/v1/acl/list')
    response = JSON.load(Net::HTTP.get(uri))

    expect(response.empty?).to eq false
  end

  it 'should return an array with JSON data' do
    uri = URI('http://localhost:8500/v1/acl/list')
    response = JSON.load(Net::HTTP.get(uri))

    expect(response.first.empty?).to eq false
    expect(response.first.to_json).to_not eq "null"
  end

  it 'should not work with an invalid token' do

  end

  it 'should work with a valid token' do

  end

  #Use FakeFS
  it 'should be able to export JSON data to filesystem' do

  end
end
