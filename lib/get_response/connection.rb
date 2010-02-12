require 'rubygems'
require 'net/http'
require 'json'

module GetResponse

  # Simple class that simulates connection to service
  class Connection
    API_URI = "http://api2.getresponse.com"

    attr_reader :api_key


    def initialize(api_key)
      @api_key = api_key
    end


    # Test connection with API.
    #
    # returns:: Boolean
    def ping
      result = self.send_request("ping")
      return result["errors"].nil?
    end


    # Get basic info about your account
    #
    # returns:: GetResponse::Account
    def get_account_info
      resp = self.send_request("get_account_info")
      GetResponse::Account.new(resp["result"])
    end


    protected


    # Send request to JSON-RPC service.
    #
    # method::  String
    #
    # params::  Hash
    def send_request(method, params = {})
      request_params = {
        :method => method,
        :params => [@api_key]
      }.to_json


      uri = URI.parse(API_URI)
      resp = Net::HTTP.start(uri.host, uri.port) do |conn|
        conn.post("/", request_params)
      end
      JSON.parse(resp.body)
    end
  end

end
