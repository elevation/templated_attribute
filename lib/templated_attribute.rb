# This file contains the extensions to <tt>ActiveRecord::Base</tt>, contained
# in the <tt>TemplatedAttribute::ActiveRecordExtensions</tt> module. See the 
# +templated_attribute+[link:classes/TemplatedAttribute/ActiveRecordExtensions/ClassMethods.html]
# method.

module TemplatedAttribute         # :nodoc:
  module ActiveRecordExtensions   # :nodoc:
    
    def self.included(base)       # :nodoc:
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      # Used to specify a template value for an attribute. A "templated attribute" has a helpful starting
      # value--kind of like a default value--except that these aren't valid data or saved in the database.
      # They're suggestions to the user about the expected formatting or content of a field.
      #
      # Unobtrusive javascript is used to populate empty form fields with their template values,
      # and a <tt>:before_validation</tt> callback is used to ensure that the template values don't
      # end up in the database. Fields which are not modified from their template values are set to
      # nil.
      #
      # Two types of templated attributes are supported:
      #
      # <tt>starting_value</tt>:: For templates where the value is the first part of potentially
      #                           valid data, like <tt>http://</tt> for URLs. The template will
      #                           remain when the user changes focus to the field to add data.
      # <tt>label</tt>::          For templates where the value is a substitute for the field's
      #                           label. The template will disappear when the user changes focus
      #                           to the field.
      #
      # Usage:
      #   class User < ActiveRecord::Base
      #     templated_attribute :website, :starting_value => 'http://'
      #     templated_attribute :phone,   :label => '(123) 555-1234'
      #     templated_attribute :bio,     :label => 'Tell us a little something about yourself.'
      #   end
      def templated_attribute(attr_name, options)
        unless included_modules.include?(InstanceMethods)
          send :include, InstanceMethods
          class_inheritable_accessor :templated_attributes_options
          before_validation :remove_unchanged_template_values
        end
        
        options.assert_valid_keys(:starting_value, :label)
        raise ArgumentError, "You must specify either :starting_value or :label" if options.size != 1
        
        template_type = options.keys.first
        template_value = options[template_type]
        
        (self.templated_attributes_options ||= {})[attr_name] = {:value => template_value, :type => template_type}
      end
    end
    
    
    module InstanceMethods    # :nodoc:
      protected
      def remove_unchanged_template_values  # :nodoc:
        templated_attributes_options.each_pair do |attr_name, options|
          value = read_attribute(attr_name)
          write_attribute(attr_name, nil) if value.nil? || value.strip == options[:value]
        end
      end
    end
  
  end
  
end