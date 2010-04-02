require 'test/unit'
require 'test_helper'

require File.dirname(__FILE__) + '/fixtures/user'

class TemplatedAttributeTest < Test::Unit::TestCase

  def setup
    User.templated_attribute :website, :starting_value => 'http://'
    @user = User.new
  end
  
  def test_raise_argument_error_on_invalid_keys_in_options_hash
    assert_raise ArgumentError do
      User.templated_attribute :name, :invalid_option => 'foo'
    end
  end
  
  def test_raise_argument_error_on_no_options_hash
    assert_raise ArgumentError do
      User.templated_attribute :name
    end
  end
  
  def test_raise_argument_Error_on_mutually_exclusive_options_both_used
    assert_raise ArgumentError do
      User.templated_attribute :email, :label => 'user@server.com', :starting_value => 'user@server.com'
    end    
  end
  
  def test_protected_instance_methods_get_defined_on_model
    assert @user.protected_methods.include?('remove_unchanged_template_values')
  end
  
  def test_class_accessor_is_created_for_options_storage
    assert_nothing_raised do
      @user.instance_variable_get(:@templated_attributes_options)
    end
  end
    
  def test_remove_unchanged_template_values_removes_template_value
    @user.website = 'http://'
    @user.valid?
    assert_equal nil, @user.website
  end
  
  def test_remove_unchanged_template_values_removes_whitespaced_template_value
    @user.website = 'http://  '
    @user.valid?
    assert_equal nil, @user.website
  end
  
  def test_remove_unchanged_template_values_maintains_nils
    @user.website = nil
    @user.valid?
    assert_equal nil, @user.website
  end
  
end
