# frozen_string_literal: true
folders = 'models,value,representers,forms,services,controllers'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
