module Marconiclient
  class Queue

    def initialize(client, name, auto_create=true)
      @client = client
      @name = name

      if auto_create
        ensure_exists 
      end
    end

    def exists?
      # Checks if the queue exists
    end

    def ensure_exists
      # Ensure the queue exists
      #
      # This method is not race safe,
      # the queue could've been deleted
      # right after it was called.

      puts 'method called.'
    end

  end
end
