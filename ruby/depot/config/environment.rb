# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Depot::Application.configure do
  # :smtp :sendmail :test
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   address: "smtp.gmail.com",
  #   port: 587,
  #   domain: "domain.of.sender.net",
  #   authentication: "plain",
  #   user_name: "dave",
  #   password: "secret",
  #   enable_starttls_auto: true
  # }
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :authentication => :plain,
    :address => "smtp.mailgun.org",
    :port => 587,
    :domain => "sandbox59647.mailgun.org",
    :user_name => "postmaster@sandbox59647.mailgun.org",
    :password => "123456789"
  }

end
