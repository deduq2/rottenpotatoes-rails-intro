class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings
    if params[:sort]
      session[:sort] = params[:sort]
    end
    if params[:ratings]
      session[:ratings] = params[:ratings]
    else
      if !session[:ratings]
        flash.keep
        redirect_to movies_path(ratings: Hash[@all_ratings.map { |r| [r, "1"] }])
      end
    end
      
    @movies = Movie.where(:rating => session[:ratings].keys)
    @checker = session[:ratings]
    
    if session[:sort]
      if session[:sort] == "title"
        @title_header_style = "hilite"
        @movies = @movies.order(:title)
      elsif session[:sort] == "release_date"
        @release_date_style = "hilite"
        @movies = @movies.order(:release_date)
      end
    end

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

end
