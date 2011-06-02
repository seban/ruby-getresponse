require "test/unit"
require File.join(File.dirname(__FILE__), "../lib/get_response")
require 'rr'

# Test helper methods


class Test::Unit::TestCase

  include RR::Adapters::TestUnit


  protected


  def get_campaigns_resp
    {
      "result" => {
        "1000" => {
          "name"              => "my_campaign_1",
          "from_name"         => "My From Name",
          "from_email"        => "me@emailaddress.com",
          "reply_to_email"    => "replies@emailaddress.com",
          "created_on"        => "2010-01-01 00:00:00"
        },
        "1001" => {
          "name"              => "my_campaign_2",
          "from_name"         => "My From Name",
          "from_email"        => "me@emailaddress.com",
          "reply_to_email"    => "replies@emailaddress.com",
          "created_on"        => "2010-01-01 00:00:00"
        }
      }
    }.to_json
  end


  def get_contacts_resp
    { "result" => {
      "45bGE" => {
        "name"=> "Sebastian N.",
        "created_on"=>"2010-04-06 07:43:32",
        "cycle_day"=>nil,
        "campaign"=>"ZyX",
        "origin"=>"api",
        "ip"=>nil,
        "email"=>"sebastian@somehost.com" },
      "55bGE" => {
        "name"=> "Sebastian N2.",
        "created_on"=>"2010-04-06 07:44:32",
        "cycle_day"=>nil,
        "campaign"=>"ZyX",
        "origin"=>"api",
        "ip"=>nil,
        "email"=>"sebastian2@somehost.com" }
    },
      "error" => nil
    }.to_json
  end


    # Fetch from fields for account.
  #
  # returns:: [FromField]
  def get_account_from_fields_resp
    {
      "result" => {
          "1024" => {
          "created_on" => "2010-12-14 00:00:00",
          "email" => "email@text.xx",
          "name" => "default"
        }
      },
      "error" => nil
    }
  end


  def add_account_from_field_success
    {
      "result" => {
        "FROM_FIELD_ID" => "abc123",
        "added" => "1"
      },
      "error" => nil
    }
  end


  def add_account_from_field_fail
    {
      "result" => nil,
      "error"  => "Invalid email syntax"
    }
  end


  def get_messages_response_success
    {
      "error" => nil,
      "result" => {
        "in9J" => {
          "flags" => ["clicktrack", "openrate"],
          "campaign" => "VzzH",
          "subject" => "Życzenia świąteczne",
          "created_on" => "2010-11-20 14:58:36",
          "type" => "newsletter",
          "send_on" => "2010-11-20 14:58:36"
        },
        "ZGVe" => {
          "flags" => ["clicktrack"],
          "campaign" => "N3i",
          "subject" => "Wysyłka",
          "created_on" => "2010-10-24 03:22:08",
          "type" => "newsletter",
          "send_on" => "2010-10-24 03:22:08"
        }
      }
    }.to_json
  end
  
end

