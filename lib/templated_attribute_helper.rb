# This file contains the extensions to ActionView::Helpers::FormHelper:
# +text_area_with_templating+[link:classes/ActionView/Helpers/FormHelper.html]
# and +text_field_with_templating+[link:classes/ActionView/Helpers/FormHelper.html].

module ActionView         #:nodoc:
  module Helpers          #:nodoc:
    
    
    # Forms which have fields for templated attributes have the following behavior:
    # * When the user visits the form, the field is pre-filled with a
    #   template value (like <tt>http://</tt>) if the real value is empty or +nil+.
    # * If the template is left unchanged, it's convert it to +nil+ before validation.
    # * To imply that the initial value is a suggestion, the field's text color is
    #   gray until the user makes a change. If the user's only change is to empty
    #   the field, we should reset it to the template value and gray again on blur.
    # * In addition to this, <tt>label</tt>-style templates blank their fields
    #   (removing the template value) when they receive focus.
    module FormHelper
      
      
      # When this plugin is installed, calls to
      # <tt>ActionView::Helpers::FormHelper#text_area</tt> in your forms will
      # transparently call this method instead.
      #
      # When you call <tt>#text_area</tt> for an attribute which is declared as
      # templated using 
      # +templated_attribute+[link:classes/TemplatedAttribute/ActiveRecordExtensions/ClassMethods.html]
      # in the model, we enhance the normal <tt>#text_area</tt>
      # by inserting templated values insetad of empty field values, and
      # appending unobtrusive Javascript to enable smart templating behavior
      # and styling on <tt><textarea></tt> tags.
      #
      # When you call <tt>#text_area</tt> for attributes which are not
      # templated, we defer to Rails's original <tt>#text_area</tt> without
      # enhhancement.
      #
      # Javascript support will be disabled if <tt>:templated_javascript =>
      # false</tt> is passed in the options hash of +text_area+.
      #
      # <b>Note:</b> The Javascript uses Prototype to add event handlers to
      # your form. Make sure <tt>prototype.js</tt> is included in your layout.
      #
      # Usage:
      #   <% form_for @user do |form| %>
      #     <label for="user_website">About you:</label>
      #     <%= form.text_area :bio %>
      #   <% end %>
      def text_area_with_templating(class_name, method, options={})
        args = [class_name, method, options]  # use params above for docs' sake
        if templated?(*args)
          field_with_templating :text_area, *args
        else
          text_area_without_templating *args
        end
      end
      alias_method_chain :text_area, :templating
      
      
      # Same as <tt>#text_area_with_templating</tt>, but overrides
      # <tt>ActionView::Helpers::FormHelper#text_field</tt> so you can get
      # templated attribute behavior with <tt><input type="text"></tt> tags.
      # See notes for <tt>#text_area_with_templating</tt> above.
      #
      # Usage:
      #   <% form_for @user do |form| %>
      #     <label for="user_website">Website:</label>
      #     <%= form.text_field :website %>
      #
      #     <label for="user_phone">Phone:</label>
      #     <%= form.text_field :phone, :templated_javascript => false %>
      #   <% end %>
      def text_field_with_templating(class_name, method, options={})
        args = [class_name, method, options]  # use params above for docs' sake
        if templated?(*args)
          field_with_templating :text_field, *args
        else
          text_field_without_templating *args
        end
      end
      alias_method_chain :text_field, :templating
      




      private
      
      
      # Helper method to determine whether or not +templated_attribute+ has
      # been called for a given class and method.
      def templated?(class_name, method, options={})  # :nodoc:
        klass = class_name_from_options_object_or_class_name(class_name, options)
        klass.respond_to?(:templated_attributes_options) && klass.templated_attributes_options[method.to_sym]
      end


      # Utility method to figure out what class the user wants to use. This
      # disambiguation is necessary so we can support both +FormHelper+ formats:
      #   form_for(@user) do |f|
      #     f.text_field :website
      #     text_field :user, :website
      #   end
      def class_name_from_options_object_or_class_name(class_name, options={})
        if options.has_key?(:object)
          options[:object].class
        else
          klass = class_name.to_s.classify.constantize
        end        
      end


      # Behind the scenes, figure out the starting value for the field, then
      # render the field normally with that value (if applicable) and append a
      # touch of Javascript to add behavior.
      def field_with_templating(field_helper, class_name, method, options = {})   # :nodoc:
        options = { :templated_javascript => true }.merge(options)
        klass = class_name_from_options_object_or_class_name(class_name, options)
        instance = options[:object] || self.instance_variable_get("@#{class_name}")
        template_options = klass.templated_attributes_options[method.to_sym]

        # If calling method on object returns nil, use template value instead
        field_value = instance.__send__(method.to_sym)
        if field_value.nil? || field_value.strip.empty?
          field_value = template_options[:value]
        end
        
        # Only use javascript if not explicitly disabled in options with
        # <tt>:templated_javascript => false</tt>
        if options.delete(:templated_javascript)
          javascript_string = javascript_tag \
            "Event.observe(window, 'load', function() { new TemplatedAttribute($('#{class_name}_#{method}'),
             '#{template_options[:type]}', '#{template_options[:value]}'); });"
        else
          javascript_string = ''
        end
        
        # output using the original method with our modified form field value,
        # plus the javascript
        send("#{field_helper}_without_templating".to_sym, klass.to_s.underscore, method, options.merge({:value => field_value})) + javascript_string
      end


    end
  end  
end