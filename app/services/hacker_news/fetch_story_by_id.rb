module HackerNews
  class FetchStoryById
    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.call(**args)
      self.new(**args).call
    end

    def call
      uri = URI("https://hacker-news.firebaseio.com/v0/item/#{id}.json")
      response = Net::HTTP.get_response(uri)
      parsed_response_body = JSON.parse(response.body)

      case response
      when Net::HTTPSuccess, Net::HTTPOK
        parsed_response_body
      else
        raise_error(error: parsed_response_body.dig('error'))
      end
    end

    private

    def raise_error(error: nil)
      error_msg = "#{self.class.name} error - #{error}"
      raise StandardError, error_msg
    end
  end
end
