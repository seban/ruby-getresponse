module GetResponse

  # Class represents list of blacklisted email addresses.
  class Blacklist

    # To instantiate new blacklist object use this method. Blacklist may contain addresses connected
    # with GetResponse account or with one particular campaign.
    #
    # Example:
    #
    #   Blacklist.new(['foo@bar', 'bar@foo'], @connection, @account)
    #
    # @param entries [Array] collection of blacklisted addresses
    # @param connection [GetResponse::Connection] connection of which all operations will be performed
    # @param ancestor [GetResponse::Account, GetResponse::Campaign] object owner of blacklist
    def initialize(entries, connection, ancestor)
      @entries = entries
      @connection = connection
      @ancestor = ancestor
    end
  end

end

