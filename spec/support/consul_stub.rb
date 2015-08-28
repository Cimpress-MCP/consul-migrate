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

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
