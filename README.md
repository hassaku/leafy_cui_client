# LeafyCuiClient

Simple CUI client for Leafy.

## Installation

Add this line to your application's Gemfile:

    gem 'leafy_cui_client', :git => 'git://github.com/hassaku/leafy_cui_client.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ git clone git@github.com:hassaku/leafy_cui_client.git
    $ cd leafy_cui_client
    $ gem build leafy_cui_client.gemspec
    $ gem install leafy_cui_client-***.gem

## Usage

    $ leafy      # read feeds
    $ leafy_post # post a message

## TODO

    - Daemonize
    - Use druby to post a message without password

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
