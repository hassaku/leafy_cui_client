module LeafyCuiClient
  class Command

    def initialize(text)
      @text = text
      @cmd = self.parse(text)
    end

    def tweet?
      @cmd.kind_of?(String)
    end

    def parse(text)
      return nil if text.nil? or text.empty?
      if text =~ /!(\S+)/
        case $1
        when 'help'
          Help.new
        when 'exit'
          Exit.new
        else
          nil
        end
      else
        text
      end
    end

    def run
      @cmd.run if @cmd
    end
  end

  class Help
    def run
      print <<-EOS
         May I help you?
      EOS
    end
  end

  class Exit
    def run
      print <<-EOS

        Good bye !!!

      EOS
      exit
    end
  end
end

