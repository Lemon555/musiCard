# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'

require 'watir'
require 'headless'
require 'page-object'

require './init.rb'

EXISTS_SEARCH = 'love'
NEW_SEARCH = 'all I want'
BAD_SEARCH = 'asfgsddhsdh'
NEW_TRACK_ID = '0bYg9bo50gSsH3LtXe2SQn'
EXISTS_TRACK_ID = '23L5CiUhw2jV1OIMwthR3S'
HEAD_OF_IMAGE = 'https://i.scdn.co/'

HOST = 'http://localhost:9000/'

# Helper methods
def homepage
  HOST
end
