module AppEnvironment
  def determineEnvironment
    environment = ENV["APP_NAME"]
    if (environment == "twreviewsite")
      "Prod"
    elsif (environment == "twreviewsite-dev")
      "QA"
    end
  end
end
