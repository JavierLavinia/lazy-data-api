# Lazy-data-api (WIP)

Fetch/send data from/to other Rails 3.2 applications.

Features:

 - Supports multiple formats (only csv now :disappointed:).
 - Clean configuration (external class).
 - Text logs.
 - Multiple actions per row (create, update, delete).
 - Globalize support.

Import-O-Matic is in development for a ruby 2 and rails 4 project, so it is only tested in this environment at the moment.

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

Add to lazy data your model:

```ruby
  class MyModel < ActiveRecord::Base
    ...
    lazy_data
    ...
  end
```

Ask your model:

```ruby
  MyModel.apiable?
```

## :video_game: Configure

### :book: Configure options:

# :white_check_mark: TODO:

- Better tests.
- Better logs.
- More ruby and rails versions.
...
