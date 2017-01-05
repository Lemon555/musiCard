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
    input = params[:input].gsub(/\s/, '%20')
    result = SearchAPIdb.call(input)
    if result.success?
      @data = result.value[:result]
      @search_terms = result.value[:search_terms]
    else
      flash[:error] = result.value.message
    end

    slim :search_result
  end

  # Get data from Spotify via our API
  post '/?' do
    input = params[:search_input].gsub(/\s/, '%20')
    result = CreateNewSearch.call(input)

    if result.success?
      flash[:notice] = 'Searching Success!'
    else
      flash[:error] = result.value.message
    end
    redirect to("/search/?input=#{input}")
  end

  # Save image to Imgur
  post '/image/?' do
    result = SaveToImgur.call(params[:url])
    if result.success?
      @imgurlink = result.value
      flash[:notice] = 'Saved!'
    else
      flash[:error] = result.value.message
    end

    redirect to("/edit/?img_url=#{@imgurlink}")
  end
end
