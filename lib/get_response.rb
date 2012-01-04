require "rubygems"
require 'json'

module GetResponse
end

GetResponse.autoload :GetResponseError, "get_response/get_response_error"
GetResponse.autoload :Account, "get_response/account"
GetResponse.autoload :Campaign, "get_response/campaign"
GetResponse.autoload :Connection, "get_response/connection"
GetResponse.autoload :Contact, "get_response/contact"
GetResponse.autoload :Message, "get_response/message"
GetResponse.autoload :CampaignProxy, "get_response/campaign_proxy"
GetResponse.autoload :ContactProxy, "get_response/contact_proxy"
GetResponse.autoload :FromField, "get_response/from_field"
GetResponse.autoload :FromFieldsProxy, "get_response/from_fields_proxy"
GetResponse.autoload :Domain, "get_response/domain"
GetResponse.autoload :DomainProxy, "get_response/domain_proxy"
GetResponse.autoload :MessageProxy, "get_response/message_proxy"
GetResponse.autoload :Newsletter, "get_response/newsletter"
GetResponse.autoload :FollowUp, "get_response/follow_up"
GetResponse.autoload :ConfirmationBody, "get_response/confirmation_body"
GetResponse.autoload :ConfirmationBodyProxy, "get_response/confirmation_body_proxy"
GetResponse.autoload :ConfirmationSubject, "get_response/confirmation_subject"
GetResponse.autoload :ConfirmationSubjectProxy, "get_response/confirmation_subject_proxy"
GetResponse.autoload :Conditions, "get_response/conditions"