# Initializer for Templated Attribute plugin

require 'templated_attribute'
require 'templated_attribute_helper'

ActiveRecord::Base.send(:include, TemplatedAttribute::ActiveRecordExtensions)

ActionView::Base.class_eval do
  include ActionView::Helpers::FormHelper
end
