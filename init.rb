# frozen_string_literal: true
folders = 'models,value,representers,forms,services,controllers,spec/pages'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
