# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'consul/migrate/version'

Gem::Specification.new do |spec|
  spec.name          = 'consul-migrate'
  spec.version       = Consul::Migrate::VERSION
  spec.authors       = ['Calvin Leung Huang']
  spec.email         = ['cleung2010@gmail.com']

  spec.summary       = 'Gem to import and export Consul ACL tokens'
  spec.description   = 'Gem that can be used to import and export Consul ACL tokens'
  spec.homepage      = 'https://github.com/Cimpress-MCP/consul-migrate'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'webmock', '~> 1.21.0'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
end
