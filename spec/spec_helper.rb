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

HOST = 'http://localhost:9000/'

# Helper methods
def homepage
  HOST
end
