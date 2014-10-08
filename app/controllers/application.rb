get '/' do 
  @links = Link.all 
  @users = User.all 
  erb :index
end
