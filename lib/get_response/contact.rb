module GetResponse

  # GetResponse contact
  class Contact
    attr_accessor :campaign, :name, :email, :cycle_day, :ip, :customs
    attr_reader :id


    def initialize(params, connection)
      @campaign = params["campaign"]
      @name = params["name"]
      @email = params["email"]
      @cycle_day = params["cycle_day"]
      @ip = params["ip"]
      @customs = parse_customs(params["customs"])
      @id = params["id"]
      @connection = connection
    end


    # Save contact object. When object can't be saved than <tt>GetResponseError</tt> is raised,
    # otherwise returns <tt>true</tt>.
    #
    # returns:: Boolean
    def save
      result = @connection.send_request(:add_contact, self.attributes)
      result["error"].nil?
    end


    # Returns setted attributes as Hash.
    #
    # returns:: Hash
    def attributes
      attrs = {
        "campaign" => @campaign,
        "name" => @name,
        "email" => @email
      }

      attrs["ip"] = @ip if @ip
      attrs["cycle_day"] = @cycle_day if @cycle_day
      attrs["customs"] = @customs if @customs

      attrs
    end


    # Delete contact. If deleting contact was successfull method returns <tt>true</tt>. If contact
    # object hasn't <tt>id</tt> attribute <tt>GetResponseError</tt> exception is raised. Exception
    # is raised when try to delete already deleted contact.
    #
    # returns:: Boolean
    def destroy
      raise GetResponse::GetResponseError.new("Can't delete contact without id") unless @id

      resp = @connection.send_request("delete_contact", { "contact" => @id })
      resp["result"]["deleted"].to_i == 1
    end


    # Update contact with passed attributes set. When object can't be saved than <tt>GetResponseError</tt>
    # is raised, otherwise returns <tt>true</tt>.
    #
    # net_attrs:: Hash
    def update(new_attrs)
      new_attrs.each_pair { |key, value| self.send(key + "=", value) }

      self.save
    end


    # Move contact from one campaign (current) to another. If move contact fails (for example: no
    # campaign with passed id) <tt>GetResponseError</tt> exception is raised, otherwise method
    # returns <tt>true</tt>.
    #
    # new_campaign_id:: String - identifier of new camapign
    # returns:: Boolean
    def move(new_campaign_id)
      param = { "contact" => @id, "campaign" => new_campaign_id }
      result = @connection.send_request("move_contact", param)
      result["result"]["updated"].to_i == 1
    end


    # Get contact geo location based on IP address from which the subscription was processed.
    #
    # returns:: Hash
    def geoip
      param = { "contact" => @id }
      @connection.send_request("get_contact_geoip", param)["result"]
    end


    # Place a contact on a desired day of the follow-up cycle or deactivate a contact. Method
    # raises a <tt>GetResponseError</tt> exception when fails otherwise returns true.
    #
    # value:: String || Fixnum
    # returns:: true
    def set_cycle(value)
      param = { "contact" => @id, "cycle_day" => value }
      @connection.send_request("set_contact_cycle", param)["result"]["updated"].to_i == 1
    end


    protected


    def parse_customs(customs)
      return unless customs
      customs.inject([]) do |customs_hash, custom|
        customs_hash << { "name" => custom[0], "content" => custom[1] }
      end
    end

  end

end

