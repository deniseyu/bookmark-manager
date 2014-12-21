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

post '/users/lost_password' do
  user = User.first(:email => params[:email])
  user.update_token
  user.send_email
  flash[:notice] = "Your password is on its way!"
  redirect '/'
end

get '/users/reset_password' do
  erb :"users/reset_password"
end

post '/users/reset_password' do
  user = User.first(:email => params[:email])
  if params[:password_token] == user.password_token
    redirect '/users/set_new_password'
  else
    flash[:notice] = 'The password token is incorrect.'
    redirect '/users/reset_password'
  end
end

get '/users/set_new_password' do
  erb :"users/set_new_password"
end

post '/users/set_new_password' do
  user = User.first(:email => params[:email])
  user.update(:password => params[:password],
              :password_confirmation => params[:password_confirmation])
  flash[:notice] = 'You have successfully set a new password'
  redirect '/sessions/new'
end



