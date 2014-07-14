module Marconiclient
  class Request

    attr_accessor :headers
    attr_reader :base_url, :version

    def initialize(url, version)
      puts 'request.initialize'
      @base_url = url
      @version = version
      @headers = Hash.new
    end

  end
end
