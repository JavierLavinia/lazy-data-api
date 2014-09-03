# Lazy-data-api (WIP)

Fetch/send data from/to other Rails 3.2 applications.

Features:
 * Simple API.
 * Dynamic routes.
 * Class namespaces support.
 * Helpers.
 * Differents configurations for each model.
 
Lazy-data-api is in development for a ruby 1.9.3 and rails 3.2 project, so it is only tested in this environment at the moment.

## :floppy_disk: Install

Add the gem to your gemfile:

```ruby
  gem 'lazy_data_api', github: 'simplelogica/lazy-data-api'
```

Install migration and configuration files

```ruby
  rails generate lazy_data_api:install
```
This adds the migration for a polymorphic association with the api ids.

And mount the engine routes into your application routes.rb:

```ruby
  Dummy::Application.routes.draw do
   mount LazyDataApi::Engine => "/lazy-data-api"
    ...
  end
```

Then, you can add lazy data to your model:

```ruby
  class MyModel < ActiveRecord::Base
    ...
    lazy_data
    ...
  end
```

And you just need to save your model to create new api_ids

```ruby
  MyModel.all.map(&:save)
```

Ask your model:

```ruby
  MyModel.apiable?
```

Add buttons helpers into your application

```ruby
  class ApplicationController < ActionController::Base
    helper LazyDataApi::ButtonsHelper
  ...
```

And use the helper 'send_lazy_data resource, options' in your views to print the send buttons:

*NOTE*: You will need to create a translation for the text button in the view. 

```ruby
  send_lazy_data post, remote: true
```

By default, with a http GET request on '/lazy-data-api/my_model/api_id', the gem exports model instance data in json format:

```ruby
  # Instance method
  def to_api
    as_json methods: :api_id, except: [:id, :created_at, :updated_at]
  end
```

And with a http POST request on '/lazy-data-api/my_model/api_id', the gem make a request GET to the referer, and create an instance with json data:

```ruby
  # Class method
  def create_api_resource attributes = {}, server_host = nil
    create attributes
  end
```

You can override this methods in each model if you need custom behavior.

## :video_game: Configure

You can use a class to configure the api. Create a class from LazyDataApi::Options in 'app/lazy_data_api_options', for example DefaultApiOptions:

```ruby
  class DefaultApiOptions < LazyDataApi::Options
    server :eu_server, protocol: 'http://', host: 'www.eu_server.com'
  end
```

And pass it to the model:

```ruby
  class MyModel < ActiveRecord::Base
    ...
    lazy_data DefaultApiOptions
    ...
  end
```

You can create a class for each model.

### :book: Configure options:

Configure the servers to send data with 'server name, url_options':

* name: just a name for the server.
* url_options: a hash with options for an url helper, 'host' at least is needed.

```ruby
  class DefaultApiOptions < LazyDataApi::Options
    server :eu_server, protocol: 'http://', host: 'www.eu_server.com'
    server :us_server, protocol: 'http://', host: 'www.us_server.com'
  end
```

You can use diferent environments and flags: 

```ruby
  class DefaultApiOptions < LazyDataApi::Options
    if Rails.application.config.main_server?
      server :eu_server, protocol: 'http://', host: 'localhost', port: '3000' if Rails.env.development?
      server :eu_server, protocol: 'https://', host: 'eu_server.staging.com' if Rails.env.staging?
      server :eu_server, protocol: 'https://', host: 'www.eu_server.com' if Rails.env.production?
    end
  end
```

# :white_check_mark: TODO:

* Security.
* Better tests.
* Better logs.
* More ruby and rails versions.
...
