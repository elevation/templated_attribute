class User < ActiveRecord::Base
  
  # Use mocked attributes so we don't have to hit the database
  attr_accessor :favorite_books
  attr_accessor :bio
  
  
  templated_attribute :bio, :label => 'Tell us about yourself.'
  
end