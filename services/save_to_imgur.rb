# frozen_string_literal: true
require 'imgur'
require 'httparty'
require 'tempfile'
# Save image to Imgur
class SaveToImgur
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(url)
    Dry.Transaction(container: self) do
      step :create_tmp_IMG_file
      step :save_to_imgur
    end.call(url)
  end

  register :create_tmp_IMG_file, lambda { |url|
    begin
      file = Tempfile.new('IMG')
      file.write HTTParty.get(url).parsed_response
      Right(url: url, file: file)
    rescue
      Left(Error.new('Our servers failed - we are investigating!'))
    end
  }

  register :save_to_imgur, lambda { |params|
    begin
      client = Imgur.new(Musicard.config.IMGUR_ID)
      image = Imgur::LocalImage.new(params[:file].path, title: 'IMG')
      uploaded = client.upload(image)
      params[:file].unlink
      Right(uploaded.link)
    rescue
      Left(Error.new("Imgur's server failed - we are investigating!"))
    end
  }
end
