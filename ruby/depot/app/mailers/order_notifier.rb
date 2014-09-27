class OrderNotifier < ActionMailer::Base
  default from: "postmaster@sandbox59647.mailgun.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #
  def received(order)
    @greeting = "Hi"
    @order = order

    mail to: "colin.lin@newbiiz.com", subject: "Success! Pragmatic Store Order Confirmation."
    # mail to: "mclxly@gmail.com", subject: "Success! Pragmatic Store Order Confirmation."
    # mail to: "legoo8@qq.com", subject: "Success! Pragmatic Store Order Confirmation."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.shipped.subject
  #
  def shipped(order)
    @greeting = "Hi"
    @order = order

    mail to: "colin.lin@newbiiz.com", subject: "Success! You shipped it."
  end
end
