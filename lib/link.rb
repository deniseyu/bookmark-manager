class Link 

  include DataMapper::Resource

  property :id,       Serial
  property :title,    String
  property :url,      String
  has n, :tags, :through => Resource 

  # start the server if ruby file executed directly
  # run! if app_file == $0
end

