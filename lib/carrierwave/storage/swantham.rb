require 'carrierwave'
require 'rest_client'

module CarrierWave
  module Storage
    class Swantham < Abstract
      def store!(file)
        f = CarrierWave::Storage::Swantham::Filee.new(uploader, self, uploader.store_path)
        f.store(file)
        f
      end

      def retrieve!(identifier)
        CarrierWave::Storage::Swantham::Filee.new(uploader, self, uploader.store_path(identifier))
      end

      class Filee
        attr_reader :path

        def initialize(uploader, base, path)
          @uploader, @base, @path = uploader, base, path
        end

        def store(file)
          RestClient.post "#{@uploader.swantham_upload_url}" ,{:myfile => ::File.new(file.path,'rb'), :typ=>@path,:multipart=>true}
          true
        end

        def url
          "#{@uploader.swantham_url}/#{path}"
        end

        def filename(options = {})
          url.gsub(/.*\/(.*?$)/, '\1')
        end

        def size
          size = nil
          data = RestClient.get @uploader.url
          size = data.size
          size
        end

        def exists?
          size ? true : false
        end

        def read
          RestClient.get @uploader.swantham_url
        end

        def content_type
          @content_type
        end

        def content_type=(new_content_type)
          @content_type = new_content_type
        end

        def delete
           RestClient.post @uploader.swantham_delete_url,{:f=>"#{@uploader.url}"}
        end

      end
    end
  end
end

CarrierWave::Storage.autoload :Swantham, "#{File.dirname(__FILE__)}/swantham"

class CarrierWave::Uploader::Base
  add_config :swantham_server_url
  add_config :swantham_upload_url
  add_config :swantham_delete_url
  add_config :swantham_url

  configure do |config|
    config.storage_engines[:swantham] = "CarrierWave::Storage::Swantham"
    config.swantham_server_url = "http://localhost:9292"
    config.swantham_upload_url = "#{config.swantham_server_url}/asset_upload"
    config.swantham_delete_url = "#{config.swantham_server_url}/asset_delete"
    config.swantham_url = "http://static.localhost"
  end
end
