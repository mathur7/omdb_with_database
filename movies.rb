require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'

# A setup step to get rspec tests running.
configure do
  root = File.expand_path(File.dirname(__FILE__))
  set :views, File.join(root,'views')
end

get '/' do
  #Add code here
  erb :search

end

get '/movies' do # or results

  c = PGconn.new(:host => "localhost", :dbname => dbname)
  @movies = c.exec_params("select * from movieinfo WHERE title = $1", [params["title"]])
  c.close
  erb :index
end
#Add code here

get '/movie/:id' do
  c = PGconn.new(:host => "localhost", :dbname => dbname)
  movies = c.exec_params("select * from movieinfo WHERE id = $1;", [params[:id]])
  # @movies_actors_common_val = c.exec_params("SELECT * FROM movies_actors INNER JOIN actors ON movies_actors.actor_id = actors.id WHERE movies_actors.movie_id = $1", [params[:id]])  
  #create movie_Actors file
  c.close
  erb :show
end

get '/movies/new' do
  erb :new
end

post '/movie' do
  c = PGconn.new(:host => "localhost", :dbname => dbname)
  c.exec_params("INSERT INTO movies (title, year) VALUES ($1, $2)",
                  [params["title"], params["year"]])
  c.close
  redirect '/'
end

def dbname
  "movies" # this might change based on your file
end

def create_movies_table
  connection = PGconn.new(:host => "localhost", :dbname => dbname)
  connection.exec %q{
  CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title varchar(255),
    year varchar(255),
    plot text,
    genre varchar(255)
  );
  }
  connection.close
end

def drop_movies_table
  connection = PGconn.new(:host => "localhost", :dbname => dbname)
  connection.exec "DROP TABLE movies;"
  connection.close
end

def seed_movies_table
  movies = [["Glitter", "2001"],
              ["Titanic", "1997"],
              ["Sharknado", "2013"],
              ["Jaws", "1975"]
             ]
 
  c = PGconn.new(:host => "localhost", :dbname => dbname)
  movies.each do |p|
    c.exec_params("INSERT INTO movies (title, year) VALUES ($1, $2);", p)
  end
  c.close
end


# join phase 4

# c = PGconn.new(:host => "localhost", :dbname => dbname)
  # movies = c.exec_params("select * from movieinfo WHERE id = $1;", [params[:id]])
  # @common_value = c.exec_params("select * from movie_actors inner join actors on movie_actors_id = actors_id where")
  # c.close
