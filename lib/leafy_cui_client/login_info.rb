module LeafyCuiClient
  class LoginInfo
    CONFIG_FILE = "#{ENV["HOME"]}/.leafyrc"
    attr_reader :email, :password, :url, :name

    def initialize
      begin
        load_from_yaml!
      rescue Errno::ENOENT
        # not found a config file
        input_from_prompt
      rescue Psych::SyntaxError
        abort "#{CONFIG_FILE} contains invalid YAML syntax."
      end
      print "Password: "
      @password = STDIN.noecho(&:gets).chop
      puts "\n"
    end

    def save!
      return if File.exist?(CONFIG_FILE)

      db = YAML::Store.new(CONFIG_FILE)
      db.transaction do
        db["login_url"] = @url
        db["email"] = @email
        db["name"] = @name
      end
    end

    private 

    def input_from_prompt
      puts "#{CONFIG_FILE} couldn't be found."
      print "Tenant name (https://***.leafy.in/): "
      @url = "https://#{STDIN.gets.chop}.leafy.in/accounts/sign_in"
      print "Email address: "
      @email = STDIN.gets.chop
      print "Screen name: "
      @name = STDIN.gets.chop
    end

    def load_from_yaml!
      config = YAML::load_file(CONFIG_FILE)
      @url = config["login_url"]
      @email = config["email"]
      @name = config["name"]
    end
  end
end
