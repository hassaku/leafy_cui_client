module LeafyCuiClient
  class Tweet
    attr_reader :author, :message, :date

    def initialize(obj)
      @obj = obj
      @author = parse('span[@class="status-author"]')
      @message = parse('span[@class="status-content"]')
      parse('div[@class="status-meta"]') =~ /\d{4}\/\d{2}\/\d{2}\s\d{2}:\d{2}/
      @date = Time.parse($& || "1970/01/01 00:00")
    end

    private
    def parse(tag)
      @obj.search(tag).inner_text.strip 
    end
  end
end
