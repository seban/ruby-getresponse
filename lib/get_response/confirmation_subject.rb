module GetResponse

  # GetResponse confirmation subject. It can be used in campaign settings.
  class ConfirmationSubject

    attr_reader :id, :content, :language_code


    def initialize(attributes)
      @id = attributes["id"]
      @content = attributes["content"]
      @language_code = attributes["language_code"]
    end

  end

end