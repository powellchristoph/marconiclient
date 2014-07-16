require 'httparty'
require 'pp'

module Marconiclient
  class Request
    include HTTParty
    format :json

    attr_accessor :options

    def initialize(url, options={})
      self.class.base_uri url
      @options = options
      default_headers = {
        'content_type' => 'application/json',
      }
      if @options[:headers]
        @options[:headers].merge!(default_headers)
      else
        @options[:headers] = default_headers
      end
    end

    def health
      # GET /v1/health
      # return 204
      Request.get("/health", @options)
    end

    def queue_exists(name)
      # GET /v1/queues/{name}
      # 204
      resp = Request.get("/queues/#{name}", @options)
      resp.code == 204
    end

    def queue_create(name)
      # PUT /v1/queues/{name}
      # 201
      Request.put("/queues/#{name}", @options) unless queue_exists(name)
    end

    def queue_delete(name)
      # DELETE /v1/queues/{name}
      # 204
      Request.delete("/queues/#{name}", @options)
    end

    def queue_list
      # GET /v1/queues{?marker,limit,detailed}
      # 200 OK
      Request.get("/queues?detailed=true", @options)
    end

  end
end
