# frozen_string_literal: true

# musiCard web application
class Musicard < Sinatra::Base
  # Home page: show list of searched groups
  # Do a basic search from our API's DB
  get '/?' do
    result = SearchAPIdb.call(params)
    if result.success?
      @data = result.value
    else
      flash[:error] = result.value.message
    end

    slim :search_result
  end

  # Get data from Spotify via our API
  post '/?' do
    result = CreateNewSearch.call(params)

    if result.success?
      @data = result.value
    else
      flash[:error] = result.value.message
    end

    redirect "/#{params}"
  end
end
