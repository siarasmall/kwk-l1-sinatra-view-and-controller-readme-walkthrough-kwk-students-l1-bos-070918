
require_relative 'config/environment'
require_relative 'models/enter_data.rb'
require_relative 'models/sorting.rb'
require 'sqlite3'




class App < Sinatra::Base
  database = SQLite3::Database.new( "new.database" )
  
  get '/' do
    erb :index
  end
  
  get '/submission' do
    erb :submission
  end
  
  post '/completed-submission' do
    @movie_title = params["title"]
    @movie_rating = params["rating"]
    @movie_tags = params["tags"]
    @movie_description = params["description"]
    @movie_image = params["image"]
    
    data_entry(@movie_title, @movie_tags, @movie_rating, @movie_description, @movie_image)
    
    erb :thank_you
  end
  
  post '/results-movies' do
    movie_searched = params["movie_searched"]
    
    @tags_from_movie = database.execute("select tags from movies where title = '#{movie_searched}'")
    
    if @tags_from_movie.length == 0 
      redirect '/submission'
    else
      tags = @tags_from_movie.split(", ")
      @sorted_list = full_sort(tags)
      erb :results
    end
  end
  
  post '/results-tags'do

    tags = params.values
    
    @sorted_list = full_sort(tags)
    
    # @sorted_list = [[1, "The Notebook", ["21st century classic", "cutie alert", "romance", "tearjerker"], "4.56", "A super cute movie!", "https://tse4.mm.bing.net/th?id=OIP.FF6lBbT09dp5VY5es6zbygHaK9&pid=Api"], [2, "Titanic", ["a cool movie", "ocean", "romance"], "5.00", "Another super cute movie!", "https://tse1.mm.bing.net/th?id=OIP.KShZDYyU79giovw5MNdXegHaLH&pid=Api"]]
    
    erb :results
    
  end
  
end



