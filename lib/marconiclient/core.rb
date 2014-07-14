require 'httparty'
require 'pp'

module Marconiclient
  module Core
    include HTTParty

    def self.health(req)
      # GET /v1/health
      # 204
      resp = self.get("#{req.base_url}/v#{req.version}/health", headers: req.headers)
      puts 'Service is unavailable.' if resp.code != 204
    end

    def self.queue_exists(req, name)
      # GET /v1/queues/{name}
      # 204
      resp = self.get("#{req.base_url}/v#{req.version}/queues/#{name}", headers: req.headers)
      resp.code == 204
    end

    def self.queue_create(req, name)
      # PUT /v1/queues/{name}
      # 201
      resp = self.put("#{req.base_url}/v#{req.version}/queues/#{name}", headers: req.headers)
      puts 'Queue not created.' if resp.code != 201
    end

    def self.queue_delete(req, name)
      # DELETE /v1/queues/{name}
      # 204
      resp = self.delete("#{req.base_url}/v#{req.version}/queues/#{name}", headers: req.headers)
      puts 'Queue not deleted.' if resp.code != 204
    end

  end
end
