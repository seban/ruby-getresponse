module GetResponse

  # GetResponse contact
  class Contact
    attr_accessor :campaign, :name, :email, :cycle_day, :ip, :customs, :created_on, :deleted_on, :reason, :duplicated
    attr_reader :id


    def initialize(params, connection)
      @campaign = params["campaign"]
      @name = params["name"]
      @email = params["email"]
      @cycle_day = params["cycle_day"]
      @ip = params["ip"]
      @customs = parse_customs(params["customs"])
      @id = params["id"]
      @created_on = params["created_on"]
      @deleted_on = params["deleted_on"]
      @reason = params["reason"]
      @connection = connection
      @duplicated = false
    end


    # Save contact object. When object can't be saved than <tt>GetResponseError</tt> is raised,
    # otherwise returns <tt>true</tt>.
    #
    # returns:: Boolean
    def save
      result = @connection.send_request(:add_contact, self.attributes)
      self.duplicated = true unless result["result"]["duplicated"].nil?
      result["error"].nil?
    end


    # Returns setted attributes as Hash.
    #
    # returns:: Hash
    def attributes
      attrs = {
        "campaign" => @campaign,
        "email" => @email
      }

      attrs["ip"] = @ip if @ip
      attrs["cycle_day"] = @cycle_day if @cycle_day
      attrs["customs"] = @customs if @customs
      attrs["name"] = @name if @name

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
      # Don't save immediately changes
      @lazy_save = true

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


    # Get list of custom attributes. It performs additional API request to fetch attributes. By
    # default new contacts has en empty custom attributes list.
    #
    # returns:: Hash
    def customs
      @connection.send_request("get_contact_customs", { "contact" => @id })["result"]
    end


    # Set custom attributes in contact instance. After set attributes you _must_ save contact.
    #
    # value:: Hash
    # returns:: Hash
    def customs=(value)
      @customs = parse_customs(value)
      @connection.send_request("set_contact_customs", { "contact" => @id, "customs" => @customs })["result"]
    end


    # List dates when the messages were opened by contact. If a contact opened the same message
    # multiple times, only the oldest date is listed.
    # returns:: Hash
    def opens
      param = {"contact" => @id}
      @connection.send_request("get_contact_opens", param)["result"]
    end


    # Set contact name. Method can raise <tt>GetResponseError</tt> exception.
    #
    # @param value [String] new name value
    # @return [String] new name value
    def name=(value)
      unless @lazy_save
        @connection.send_request("set_contact_name", { "contact" => @id, "name" => value })["result"]
      end
      @name = value
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

