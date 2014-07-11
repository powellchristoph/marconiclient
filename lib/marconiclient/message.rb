module Marconiclient
  class Message

    def initialize(queue, href, ttl, age, body)
      @queue = queue
      @href = href
      @ttl = ttl
      @age = age
      @body = body
    end

    def claim_id
    end

    def delete
    end

  end
end
