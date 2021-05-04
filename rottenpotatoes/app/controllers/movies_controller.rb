class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @sort = params[:sort] || session[:sort]
    @all_ratings = Movie.ratings
    @ratings =  params[:ratings] || session[:ratings] || Hash[@all_ratings.map {|rating| [rating, rating]}]
    @movies = Movie.where(rating:@ratings.keys).order(@sort)
    
    if params[:sort]!=session[:sort] or params[:ratings]!=session[:ratings]
      session[:sort] = @sort
      session[:ratings] = @ratings
      flash.keep
      redirect_to movies_path(sort: session[:sort],ratings:session[:ratings])
    end
    
  end
  
  def search
    # puts(pus)
    @movies = Movie.search_by_director(params[:title])
    if @movies.nil?
      # puts "Nulll"
      redirect_to root_url, alert: "'#{params[:title]}' has no director info"
    end 

    @movie = Movie.find_by(title: params[:title])
    # puts("hell-" , @movies.inspect)
    # Movie.all
    # redirect_to movies_path(@movies)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
