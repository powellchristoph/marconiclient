require 'httparty'
require 'json'
require 'pp'

require_relative 'exceptions'

module Marconiclient
  class Request
    include HTTParty
    format :json

    attr_accessor :options

    def initialize(url, options={})
      self.class.base_uri url
      @options = options
      default_headers = {
        'Content-Type' => 'application/json',
      }
      if @options[:headers]
        @options[:headers].merge!(default_headers)
      else
        @options[:headers] = default_headers
      end
    end

    def output(response)
      puts "##########################"
      begin
        puts "Body: ", response.body
        puts "Code: ", response.code if response.code
        puts "Message: ", response.message if response.message
        puts "Headers: ", response.headers.inspect if response.headers
      rescue
        pp response
      end
      puts "##########################"
    end

    def error(code)
      errors = Marconiclient::ERRORS
      if errors.has_key?(code)
        "#{errors[code]} received."
      else
        "#{code} received, unknown error."
      end
    end

    def health
      # GET /v1/health
      # return 204
      response = Request.get("/health", @options)
      raise ResponseError, error(response.code) unless response.code == 204
    end

    def queue_exists(name)
      # GET /v1/queues/{name}
      # 204
      resp = Request.get("/queues/#{name}", @options)
      if resp.code == 204
        true
      elsif resp.code == 404
        false
      else
        raise ResponseError, error(resp.code)
      end
    end

    def queue_create(name)
      # PUT /v1/queues/{name}
      # 201
      resp = Request.put("/queues/#{name}", @options)
      raise ResponseError, error(resp.code) unless resp.code == 201
    end

    def queue_delete(name)
      # DELETE /v1/queues/{name}
      # 204
      resp = Request.delete("/queues/#{name}", @options)
      raise ResponseError, error(resp.code) unless resp.code == 204
    end

    def queue_list(limit: 20, detailed: true)
      # GET /v1/queues{?marker,limit,detailed}
      # 200 OK
      # TODO: Add follow links to get more than 20 queues
      @options[:query] = {
        :limit => limit,
        :detailed => detailed }
      resp = Request.get("/queues", @options)
      if resp.code == 200
        JSON.parse(resp.body, symbolize_names: true)
      elsif resp.code == 204
        {:links => [], :queues => []}
      else
        raise ResponseError, error(resp.code) unless resp.code == 200
      end
    end

    def queue_get_metadata(name)
      # GET /v1/queues/{queue_name}/metadata
      # 200 OK
      resp = Request.get("/queues/#{name}/metadata", @options)
      raise ResponseError, error(resp.code) unless resp.code == 200
      JSON.parse(resp.body, symbolize_names: true)
    end

    def queue_set_metadata(name)
      # PUT /v1/queues/{queue_name}/metadata
      # 204 No Content
      resp = Request.put("/queues/#{name}/metadata", @options)
      raise ResponseError, error(resp.code) unless resp.code == 204
    end

    def queue_get_stats(name)
      # GET /v1/queues/{queue_name}/stats
      # 200 OK
      resp = Request.get("/queues/#{name}/stats", @options)
      raise ResponseError, error(resp.code) unless resp.code == 200
      JSON.parse(resp.body, symbolize_names: true)
    end

    def message_list(name, limit: 10, echo: false, marker: nil, include_claimed: false)
      @options[:query] = {
        :limit => limit,
        :echo => echo,
        :marker => marker,
        :include_claimed => include_claimed}
      resp = Request.get("/queues/#{name}/messages", @options)
      if resp.code == 200
        JSON.parse(resp.body, symbolize_names: true)
      elsif resp.code == 204
        {:links => [], :messages => []}
      else
        raise ResponseError, error(resp.code)
      end
    end

    def message_get_many(name, messages, limit: 10, echo: false, marker: nil, include_claimed: false)
      raise 'Funcion not implemented.'
#      @options[:query] = {
#        :limit => limit,
#        :echo => echo,
#        :marker => marker,
#        :include_claimed => include_claimed}
#      resp = Request.get("/queues/#{name}/messages", @options)
#      if resp.code == 200
#        JSON.parse(resp.body, symbolize_names: true)
#      elsif resp.code == 204
#        nil
#      else
#        raise ResponseError, error(resp.code)
#      end
    end

    def message_post(name, messages)
      # POST /v1/queues/{queue_name}/messages
      # 201 Created

      @options[:body] = messages.to_json
      resp = Request.post("/queues/#{name}/messages", @options)
      raise ResponseError, error(resp.code) unless resp.code == 201
      JSON.parse(resp.body, symbolize_names: true)
    end

    def message_get(name, id)
      resp = Request.get("/queues/#{name}/messages/#{id}", @options)
      raise ResponseError, error(resp.code) unless resp.code == 200
      JSON.parse(resp.body, symbolize_names: true)
    end


    def message_delete
    end

    def claim_create
    end

    def claim_get
    end

    def claim_update
    end

    def claim_delete
    end

  end
end
