require 'rubygems'
require 'net/http'
require 'json'

module GetResponse

  # Simple class that simulates connection to service
  class Connection
    API_URI = "http://api2.getresponse.com"

    attr_reader :api_key


    private_class_method :new


    def initialize(api_key)
      @api_key = api_key
    end


    def self.instance(api_key = "")
      @@instance ||= new(api_key)
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


    # Get list of active campaigns in account. There are allowed operators for building conditions.
    # More info about operators http://dev.getresponse.com/api-doc/#operators
    #
    #   gr_connection.get_campaings
    #
    # Get list of all active campaigns with name "my_campaign" and from_email is from domain "mybiz.xx"
    #
    #   gr_connection.get_campaings(:name.is_eq => "my_campaign", :from_email.contain => "%mybiz.xx")
    #
    # get_campaings(:name.eq => "my name")
    def get_campaigns(conditions = {})
      req_cond = conditions.inject({}) do |hash, cond|
        hash.merge!(cond[0].evaluate(cond[1]))
        hash
      end

      response = send_request("get_campaigns", req_cond)["result"]
      response.inject([]) do |campaings, resp|
        campaings << Campaign.new(resp[1].merge("id" => resp[0]))
      end
    end


    # Get single campaign using <tt>campaign_id</tt>.
    #
    # campaign_id:: Integer || String
    #
    # returns:: GetResponse::Campaign || nil
    def get_campaign(campaign_id)
      result = self.get_campaigns(:id.is_eq => campaign_id)
      result.first
    end


    # Send request to JSON-RPC service.
    #
    # method::  String
    #
    # params::  Hash
    def send_request(method, params = {})
      request_params = {
        :method => method,
        :params => [@api_key, params]
      }.to_json

      uri = URI.parse(API_URI)
      resp = Net::HTTP.start(uri.host, uri.port) do |conn|
        conn.post("/", request_params)
      end
      JSON.parse(resp.body)
    end
  end

end
