# CarrierWave - Swantham Asset server storage

This gem adds support for Swantham Asset server to [CarrierWave](https://github.com/jnicklas/carrierwave/)

Swantham means "Own" in Malayalam(http://en.wikipedia.org/wiki/Malayalam)

*** No Tests Yet ***

## Installation

Download code and place it in the "lib" folder

Require it in your code(add a new intializer):

    require 'carrierwave/storage/swantham'

## Getting Started 

Configure CarrierWave with your Swantham Asset urls:

```ruby
CarrierWave.configure do |config|i
    config.swantham_server_url = "http://sw-asset.host:9292"
    config.swantham_url = "http://static.yoursite.com"
end
```

And then in your uploader, set the storage to `:swantham`:

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :swantham
end
```

