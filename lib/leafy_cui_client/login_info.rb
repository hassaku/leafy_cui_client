module LeafyCuiClient
  class LoginInfo
    CONFIG_FILE = "#{ENV["HOME"]}/.leafyrc"
    attr_reader :tenant, :email, :password, :url, :name

    def initialize
      begin
        load_from_yaml!
      rescue Errno::ENOENT
        input_from_prompt
      rescue Psych::SyntaxError
        abort "#{CONFIG_FILE} contains invalid YAML syntax."
      end
      print "Password: "
      system "stty -echo"
      @password = $stdin.gets.chop
      system "stty echo"
      puts "\n"
    end

    def save!
      db = YAML::Store.new(CONFIG_FILE)
      db.transaction do
        db[@tenant] = {"login_url" => @url, "email" => @email, "name" => @name}
      end
    end

    private 

    def input_from_prompt
      puts "#{CONFIG_FILE} or the selected tenant couldn't be found."
      print "Tenant name (https://***.leafy.in/): "
      @tenant = STDIN.gets.chop
      @url = "https://#{@tenant}.leafy.in/accounts/sign_in"
      print "Email address: "
      @email = STDIN.gets.chop
      print "Screen name: "
      @name = STDIN.gets.chop
    end

    def load_from_yaml!
      tenants = YAML::load_file(CONFIG_FILE)
      raise Errno::ENOENT unless tenants

      print "Input tenant name(#{tenants.keys.join('|')}|others): "
      @tenant = STDIN.gets.chop
      config = tenants[@tenant]
      raise Errno::ENOENT unless config

      @url = config["login_url"]
      @email = config["email"]
      @name = config["name"]
    end
  end
end
