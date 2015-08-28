require 'spec_helper'

# TDOD: Refactor test cases to group by same URI/requests

describe Consul::Migrate do
  it 'has a version number' do
    expect(Consul::Migrate::VERSION).not_to be nil
  end
end
