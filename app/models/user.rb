require 'bcrypt'
require 'mailgun'

class User

  attr_accessor :password, :password_confirmation

  include DataMapper::Resource

  property :id,               Serial
  property :email, String, :unique => true, :message => "This email is already taken"
  property :password_digest,  Text
  property :password_token,   Text
  property :password_token_timestamp, Time

  validates_uniqueness_of :email
  validates_confirmation_of :password
  # user will be saved only if passwords match

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(:email => email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end

  def generate_token
    (1..64).map{ ('A'..'Z').to_a.sample }.join
  end

  def update_token
    self.password_token = generate_token
    self.password_token_timestamp = Time.now
    self.save!
  end

  def send_email
    RestClient.post("https://api:key-a88164d5295ed36792cb01e75ffef0c6"\
    "@api.mailgun.net/v2/sandbox147ff18ab35e48b28c499ac32b634ce2.mailgun.org/messages",
    :from => "Mailgun Sandbox <postmaster@sandbox147ff18ab35e48b28c499ac32b634ce2.mailgun.org>",
    :to => "#{self.email}",
    :subject => "D'oh! You lost your password!",
    :text => "That's OK. Enter the following unique token into this form to reset your password.
    <br>#{self.password_token}
    <br>For security reasons, this token will expire at #{self.password_token_timestamp + 3600}. <a href='http://localhost:9292/users/reset_password'>Click here!</a>.")
  end

end