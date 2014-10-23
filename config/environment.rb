# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ReviewSite::Application.initialize!

Date::DATE_FORMATS[:short_date] = "%b. %d, %Y"
Time::DATE_FORMATS[:short_date] = "%b. %d, %Y"
