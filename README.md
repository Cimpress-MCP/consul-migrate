# consul-migrate

consul-migrate is a Ruby gem for migrating Consul's ACL datacenter. Consul does not natively support such migration mechanism, but does provide an API for accessing ACLs. consul-migrate uses this API to export ACL tokens from the current authoritative ACL datacenter and import them to another datacenter.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consul-migrate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install consul-migrate

## Usage
From the current authoritative ACL datacenter:

```ruby
require 'consul/migrate'

client = Consul::Migrate::Client.new(acl_token: 'your-acl-master-token')
client.export_acls('/path/to/file')
```

From the desired new ACL datacenter:
```ruby
require 'consul/migrate'
client = Consul::Migrate::Client.new(acl_token: 'your-acl-master-token')
client.import_acls('/path/to/file')
```

## CLI
Basic usage commands:
```
$ consul-migrate init -t 'your-acl-master-token'
$ consul-migrate export -f 'path/to/file'
$ consul-migrate import -f 'path/to/file'
```

Refer to `consul-migrate help` for more detailed usage commands.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/consul-migrate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## TODO

1. Spec test should also test for default policy allow case
