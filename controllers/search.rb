# frozen_string_literal: true

# musiCard web application
class Musicard < Sinatra::Base
  # Home page: Initial App Page
  get '/?' do
    slim :home, layout: false
  end

  # Edit Image page
  get '/edit/?' do
    @image_url = params[:img_url]
    slim :edit_image
  end

  # Do a basic search from our API's DB
  get '/search/?' do
    result = SearchAPIdb.call(params[:input])
    if result.success?
      @data = result.value
    else
      flash[:error] = result.value.message
    end

    slim :search_result
  end

  # Get data from Spotify via our API
  post '/?' do
    result = CreateNewSearch.call(params[:search_input])

    if result.success?
      flash[:notice] = 'Searching Success!'
    else
      flash[:error] = result.value.message
    end
    redirect to("/search/?input=#{params[:search_input]}")
  end
end
