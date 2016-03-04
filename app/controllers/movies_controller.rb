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

    @all_ratings=Movie.pluck(:rating).uniq
    
    if params[:sort]
      @sort=params[:sort]
      session[:sort]=@sort
    else
      @sort=session[:sort]
    end 

    if params[:ratings]
      @rating=params[:ratings].keys
      session[:ratings]=params[:ratings]
    else
      if session[:ratings]
        @rating=session[:ratings].keys
      else
        @rating=all_ratings
      end
    end

    @movies_prepare=Movie.all.select{|x| @rating.include? x.rating}
    if @sort
      @movies= @movies_prepare.sort{|x,y| x.send(@sort) <=> y.send(@sort)}
    else
      @movies=@movies_prepare
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
