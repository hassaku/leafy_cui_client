require "leafy_cui_client/version"
require "leafy_cui_client/leafy"
require "leafy_cui_client/tweet"
require "leafy_cui_client/login_info"
require "leafy_cui_client/command"

require 'time'
#require 'io/console' # only if RUBY_VERSION >= '1.9.3'
require 'yaml'
require "yaml/store"
require 'psych'
require 'tempfile'

require 'mechanize'
require 'rainbow'
require 'thread'
require 'readline'

module LeafyCuiClient
  def self.run!(interval_sec = 60)
    Thread.abort_on_exception = true

    #daemonize

    leafy_agent = LeafyCuiClient::Leafy.new
    leafy_agent.login!
    leafy_agent.view

    message_queue = Queue.new
    leafy_poster = Thread.new do
      loop do
        next if message_queue.empty?
        message = message_queue.pop
        leafy_agent.post(message)
        sleep 5 # サーバ負荷を考慮して5秒おきにQueueを処理する
      end
    end

    loop do
      begin
        Timeout.timeout(interval_sec) do
          stty_save = `stty -g`.chomp
          begin
            while line = Readline::readline('> ', true)
              cmd = Command.new(line)
              if cmd.tweet?
                message_queue.push(line)
              else
                cmd.run
              end
            end
          rescue Interrupt
            system("stty", stty_save)
            exit
          end
        end
      rescue Timeout::Error
        leafy_agent.view
        next
      end
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
