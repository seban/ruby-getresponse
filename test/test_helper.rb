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


  def get_message_contents
    {
      "error" => nil,
      "result" => {
        "plain" => "Hello there!",
        "html" => "<h1>Hello</h1> there!"
      }
    }.to_json
  end


  def get_message_stats
    {
      "error" => nil,
      "result" => {
        "2010-01-01" => {
          "sent" => "1024",
          "opened" => "512",
          "clicked" => "128",
          "bounces_user_unknown" => "8",
          "bounces_mailbox_full" => "2",
          "bounces_block_content" => "0",
          "bounces_block_timeout" => "0",
          "bounces_block_other" => "1",
          "bounces_other_soft" => "16",
          "bounces_other_hard" => "2",
          "complaints_handled" => "1",
          "complaints_unhandled" => "0"
        },
        "2010-01-02" => {
          "sent" => "0",
          "opened" => "64",
          "clicked" => "16",
          "bounces_user_unknown" => "0",
          "bounces_mailbox_full" => "1",
          "bounces_block_content" => "0",
          "bounces_block_timeout" => "0",
          "bounces_block_other" => "0",
          "bounces_other_soft" => "2",
          "bounces_other_hard" => "0",
          "complaints_handled" => "1",
          "complaints_unhandled" => "0"
        }
      }
    }.to_json
  end


  def get_postal_address
    {
      "result" => {
        "name" => "My name",
        "address" => "My address",
        "city" => "My city",
        "state" => "My state",
        "zip" => "My zip",
        "country" => "My country",
        "design" => "[[name]], [[address]], [[city]], [[state]] [[zip]], [[country]]"
      },
      "error" => nil
    }.to_json
  end


  def get_contact_subscription_stats_response
    {
      "result" => {
        "2010-01-01" => {
          "n3i" => {
            "iphone" => 0,
            "www" => 32,
            "sale" => 64,
            "leads" => 2,
            "forward" => 0,
            "panel" => 4,
            "api" => 128,
            "import" => 0,
            "email" => 16,
            "survey" => 1
          },
          "pou" => {
            "iphone" => 8,
            "www" => 0,
            "sale" => 0,
            "leads" => 64,
            "forward" => 0,
            "panel" => 0,
            "api" => 512,
            "import" => 16,
            "email" => 0,
            "survey" => 0
          }
        },
        "2010-01-02" => {
          "n3i" => {
            "iphone" => 0,
            "www" => 64,
            "sale" => 128,
            "leads" => 8,
            "forward" => 1,
            "panel" => 8,
            "api" => 1024,
            "import" => 0,
            "email" => 2,
            "survey" => 8
          },
          "pou" => {
            "iphone" => 0,
            "www" => 0,
            "sale" => 0,
            "leads" => 128,
            "forward" => 0,
            "panel" => 0,
            "api" => 2048,
            "import" => 0,
            "email" => 0,
            "survey" => 0
          }
        }
      },
    "error" => nil
    }.to_json
  end


  def get_contacts_deleted_resp
    {"result" => {
      "45bGE" => {
        "name"=> "Sebastian N.",
        "created_on"=>"2010-04-06 07:43:32",
        "deleted_on"=>"2010-04-06 07:43:32",
        "cycle_day"=>nil,
        "campaign"=>"ZyX",
        "origin"=>"api",
        "ip"=>nil,
        "email"=>"sebastian@somehost.com",
        "reason"=>'bounce'},
      "55bGE" => {
        "name"=> "Sebastian N2.",
        "created_on"=>"2010-04-06 07:44:32",
        "deleted_on"=>"2010-04-06 07:43:32",
        "cycle_day"=>nil,
        "campaign"=>"ZyX",
        "origin"=>"api",
        "ip"=>nil,
        "email"=>"sebastian2@somehost.com",
        "reason"=>"bounce"}
    },
     "error" => nil
    }.to_json
  end


  def confirmation_body_response
    {
      "result" => {
        "1001" => {
          "plain" => "Please click to confirm ...",
          "html" => "<p>Please click to confirm ...",
          "language_code" => "en"
        }
      },
      "error" => nil
    }
  end


  def get_confirmation_subject_response
    {
      "result" => {
        "1001" => {
          "content" => "Please confirm subscription",
          "language_code" => "en"
        },
      "error" => nil
      }
    }
  end


  def get_links_response
    {
      "result" => {
        "1024" => {
          "message" => "oxc",
          "name" => "My Home Page",
          "url" => "http://myhomepage.com",
          "clicks" => 32
        },
        "1025" => {
          "message" => "oxd",
          "name" => "My product 1",
          "url" => "http://myhomepage.com?product=1",
          "clicks" => 16
        }
      },
      "error" => nil
    }
  end


  def get_blacklist_response
    {
      "result" => {
        "my_contact_1@emailaddress.com" => "2010-01-01 00:00:00",
        "my_contact_2@emailaddress.com" => "2010-01-01 00:00:00"
      },
      "error" => nil
    }
  end

end

