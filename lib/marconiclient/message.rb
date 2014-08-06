module Marconiclient
  class Message

    attr_reader :queue, :href, :ttl, :age, :body

    def initialize(queue, options={})
      @queue = queue
      @href = options[:href]
      @ttl = options[:ttl]
      @age = options[:age]
      @body = options[:body]

      # The url has two forms depending on if it has been claimed.
      # /v1/queues/worker-jobs/messages/5c6939a8?claim_id=63c9a592
      # or
      # /v1/queues/worker-jobs/messages/5c6939a8
      @id = @href.split('/')[-1]
      if @id.include? "?"
        @id = @id.split('?')[0]
      end
    end

    def claim_id
      if @id.include? "="
        @id.split('=')[-1]
      end
    end

    def delete
    end

  end
end
