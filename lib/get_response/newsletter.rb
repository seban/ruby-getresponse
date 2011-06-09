module GetResponse

  class Newsletter < Message

    # Delete newsletter. You can delete only newsletters that have send_on date in future. If you try
    # to delete exception will be raised.
    def destroy
      resp = @connection.send_request("delete_newsletter", :message => @id)["result"]
      resp["deleted"].to_i == 1
    end

  end

end

