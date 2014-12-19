get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/users' do
  user = User.new(:email => params[:email],
              :password => params[:password],
              :password_confirmation => params[:password_confirmation])
    if user.save
      session[:user_id] = user.id
      redirect to('/')
    else
      flash.now[:errors] = user.errors.full_messages
      erb :"users/new"
    end
end

get '/users/lost_password' do
  erb :'users/lost_password'
end

post '/users/reset_password' do
  user = User.first(:email => params[:email])
  user.update_token
  user.send_email
  flash[:notice] = "Your password is on its way!"
  redirect '/'
end

get '/users/choose_new_password/:token' do
  user = User.first(:password_token => params[:token])
  erb :reset_password
end

post '/users/choose_new_password' do
  user = User.first(:password_token => token)
end



