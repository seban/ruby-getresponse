module GetResponse

  # GetResponse confirmation body. It can be used in campaign settings.
  class ConfirmationBody

    attr_reader :id, :plain, :html, :language_code


    def initialize(attributes)
      @id = attributes["id"]
      @plain = attributes["plain"]
      @html = attributes["html"]
      @language_code = attributes["language_code"]
    end

  end

end