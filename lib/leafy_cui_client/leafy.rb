# -*- encoding: utf-8 -*-
module LeafyCuiClient
  class Leafy
    def initialize
      @info = LoginInfo.new
      @latest_date = Time.parse("1970/01/01 00:00")
    end

    def login!
      @agent = Mechanize.new
      if proxy = ENV['HTTP_PROXY'] || ENV['http_proxy']
        uri = URI.parse(proxy)
        @agent.set_proxy(uri.host, uri.port, uri.user, uri.password)
      end

      login_form = @agent.get(@info.url).form
      login_form.field_with(name: 'user[email]').value = @info.email
      login_form.field_with(name: 'user[password]').value = @info.password

      begin
        @agent.submit(login_form)
      rescue => ex
        abort "#{ex}\nAborting due to invalid authentication."
      else
        @info.save!
      end
    end

    def post
      message = input_with_editor
      message_form = @agent.page.form(id: 'new_status')
      message_form.field_with(name: 'status[text]').value = message
      if message.empty?
        abort "\nAborting post due to empty message."
      end
      puts "Sending following message :"
      puts message
      @agent.submit(message_form)
    end

    def view
      tweets = @agent.page.search('div[@class="status-body"]').inject([]) {|ts, obj| ts << Tweet.new(obj) }
      tweets.reverse.each do |tweet|
        next if tweet.date.to_i <= @latest_date.to_i
        puts "-" * 20
        tweet.author.gsub!(/#{@info.name}/, @info.name.color(:red).background(:white).blink)
        puts "[#{tweet.author} - #{tweet.date}]".color(:cyan)
        puts decorated tweet.message
      end
      print "."
      @latest_date = tweets.first.date
    end

    private
    def input_with_editor
      abort "External variable LEAFY_EDITOR isn't set!" unless editor = ENV['LEAFY_EDITOR']
      tmp = Tempfile.new('deleted_soon')
      system(editor + " " + tmp.path)
      message = File.open(tmp.path).readlines.join
      tmp.unlink # delete the temp file
      message
    end

    def decorated(message)
      message.gsub!(/http.+/, "")
      message = wrap_long_string(message, 40)
      message.gsub!(/@#{@info.name}/, "@#{@info.name}".color(:red).background(:white).blink.bright)
      message
    end

    def wrap_long_string(text, max_width = 30)
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : text.scan(regex).join("\r\n")
    end
  end
end
