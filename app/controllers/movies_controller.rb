class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    
  end

  def index
    @all_ratings = Movie.all_ratings
    
    if session[:ratings].nil?
      @ratings_to_show = params[:ratings].nil? ? [] : params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif params[:commit].nil?
      @ratings_to_show = session[:ratings].nil? ? [] : session[:ratings].keys
    else
      @ratings_to_show = params[:ratings].nil? ? [] : params[:ratings].keys
      session[:ratings] = params[:ratings]
    end 
    
    @ratings_to_show_hash = Hash[@ratings_to_show.collect {|x| [x, '1']}]
    
    if session[:sort].nil?
      @sorting = params[:sort] 
      session[:sort] = params[:sort]
    elsif (params[:sort]!=session[:sort] and !params[:sort].nil?)
      @sorting = params[:sort]
      session[:sort] = params[:sort]
    else
      @sorting = session[:sort]
    end 
    
    if @sorting.nil? 
      @movies = Movie.with_ratings(@ratings_to_show)
    else
      @movies = Movie.order(@sorting).with_ratings(@ratings_to_show)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    session.clear
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    session.clear
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    session.clear
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
