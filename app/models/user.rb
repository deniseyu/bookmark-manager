require 'bcrypt'
require 'mailgun'

class User

  attr_reader :password
  attr_accessor :password_confirmation

  include DataMapper::Resource

  property :id,               Serial
  property :email, String, :unique => true, :message => "This email is already taken"
  property :password_digest,  Text
  property :password_token,   Text
  property :password_token_timestamp, Text

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
    (1..64).map{ ('A'..'Z').to_a.sample}.join
  end

  def update_token
    self.password_token = generate_token
    self.password_token_timestamp = Time.now
    self.save!
  end

  def send_email

    mg_client = Mailgun::Client.new "key-a88164d5295ed36792cb01e75ffef0c6"
    message_params =  {:from => 'help@bookmark-manager.com',
                      :to => 'yu.denise.d@gmail.com',
                      :subject => 'Password Retrieval Request',
                      :text => 'Yay it worked'
                      }
    mg_client.send_message "https://localhost:9292/users/reset_password", message_params
  end





end