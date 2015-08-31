require 'spec_helper'
require 'support/consul_stub'


describe "mock" do

  it 'should not work without a valid token' do
    uri = URI('http://localhost:8500/v1/acl/list?token=no-valid-dummy-token')
    response = Net::HTTP.get_response(uri)

    expect(response.code).to eq "403"
  end

  it 'should work with a valid token' do
    uri = URI('http://localhost:8500/v1/acl/list?token=dummy-token')
    response = Net::HTTP.get_response(uri)

    expect(response.code).to eq "200"
  end

  it 'should return a non-empty response' do
    uri = URI('http://localhost:8500/v1/acl/list?token=dummy-token')
    response = JSON.load(Net::HTTP.get(uri))

    expect(response.empty?).to eq false
  end

  it 'should return an array with JSON data' do
    uri = URI('http://localhost:8500/v1/acl/list?token=dummy-token')
    response = JSON.load(Net::HTTP.get(uri))

    expect(response.first.empty?).to eq false
    expect(response.first.to_json).to_not eq "null"
  end

  it 'should work with PUT' do
    uri = URI('http://localhost:8500/hello')
    req = Net::HTTP::Put.new(uri)

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    expect(response.code).to eq "200"
  end
end
