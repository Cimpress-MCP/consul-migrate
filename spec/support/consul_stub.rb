require 'sinatra/base'

class ConsulStub < Sinatra::Base
  get '/v1/acl/list' do
    if params['token'] == 'dummy-token'
      json_response 200, 'acls.json'
    else
      content_type 'text/plain'
      status 403
      "rpc error: rpc error: Permission denied"
    end
  end

  put '/v1/acl/create' do
    if params['token'] == 'dummy-token'
      data = { :ID => 'abc' }
      # data = JSON.parse(request.body.read)
      content_type :json
      status 200
      data[:ID]
    else
      content_type 'text/plain'
      status 403
      "rpc error: rpc error: Permission denied"
    end
  end

  put '/hello' do
    status 200
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
