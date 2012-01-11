module GetResponse

  # Class represents list of blacklisted email addresses.
  class Blacklist

    def initialize(*args)
      @connection = args.pop
      @list = args
    end
  end

end

