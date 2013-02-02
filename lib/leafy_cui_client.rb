require "leafy_cui_client/version"
require "leafy_cui_client/leafy"
require "leafy_cui_client/tweet"
require "leafy_cui_client/login_info"

require 'time'
require 'io/console'
require 'yaml'
require "yaml/store"
require 'tempfile'

require 'mechanize'
require 'rainbow'

module LeafyCuiClient
  def self.run!(interval_sec = 60)
    #daemonize
    leafy = LeafyCuiClient::Leafy.new
    loop do
      leafy.login!
      leafy.view
      sleep(interval_sec)
    end
  end

  def self.post!
    leafy = LeafyCuiClient::Leafy.new
    leafy.login!
    leafy.post
  end

  private
  def daemonize
    if Process.respond_to? :daemon  # Ruby 1.9
      Process.daemon
    else                            # Ruby 1.8
      require 'webrick'
      WEBrick::Daemon.start
    end
  end
end
