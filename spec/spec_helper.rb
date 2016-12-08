# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'

require 'watir'
require 'headless'
require 'page-object'

require './init.rb'

EXISTS_SEARCH = 'love'
NEW_SEARCH = 'cake'
BAD_SEARCH = 'asfgsddhsdh'
NEW_TRACK_ID = '76hfruVvmfQbw0eYn1nmeC'
EXISTS_TRACK_ID = '23L5CiUhw2jV1OIMwthR3S'

HOST = 'http://localhost:9000/'

# Helper methods
def homepage
  HOST
end
