module GetResponse

  class FollowUp < Message

    # Delete follow up message.
    def destroy
      response = @connection.send_request("delete_follow_up", :message => @id)["result"]
      response["deleted"].to_i == 1
    end

  end

end

