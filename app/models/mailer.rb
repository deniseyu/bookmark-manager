class Mailer 

  def send_simple_message
    RestClient.post "https://api:key-11a0a3b611438560a241dea99cfff4a4"\
    "@api.mailgun.net/v2/samples.mailgun.org/messages",
    :from => "Bookmark Manager Support <app30526281.mailgun.org>",
    :to => "yu.denise.d@gmail.com",
    :subject => "Here is your password reset token",
    :text => "Your token is #{self.generate_token}. It will expire within one hour. <a href='/users/reset_password'>Click here to reset your password!</a>"
  end

end