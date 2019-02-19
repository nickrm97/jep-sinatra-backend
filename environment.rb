require 'mongoid'
Mongoid.raise_not_found_error = false
Mongoid.load!("./config/mongoid.yml", :development)
require_relative 'models/rating_question'
