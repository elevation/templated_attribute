require 'test_helper'
require 'action_controller/test_process'
require File.dirname(__FILE__) + '/fixtures/user'


# Simple RESTful routes for UsersController below
ActionController::Routing::Routes.draw do |map|
  map.resources :users
end


# Simple controller to return different Erb templates; hijack 'new' to display templates
# for an unsaved record, and 'edit' to display templates for records that already have
# saved data.
class UsersController < ActionController::Base

  # re-raise exceptions so they bubble up
  def rescue_action(e) raise e end;
    
  # for testing templated attributes on new records (where all fields have nil values)
  def new
    @user = User.new
    if (params[:style] == :short)
      render :inline => case params[:attribute]
        when :bio            then '<% form_for @user do |f| %>  <%= f.text_area :bio %>  <% end %>'
        when :bio_no_js      then '<% form_for @user do |f| %>  <%= f.text_area :bio, :templated_javascript => false %>  <% end %>'
        when :favorite_books then '<% form_for @user do |f| %>  <%= f.text_area :favorite_books %>  <% end %>'
        else                      ''
      end
    else
      render :inline => case params[:attribute]
        when :bio            then '<% form_for @user do %>  <%= text_area :user, :bio %>  <% end %>'
        when :bio_no_js      then '<% form_for @user do %>  <%= text_area :user, :bio, :templated_javascript => false %>  <% end %>'
        when :favorite_books then '<% form_for @user do %>  <%= text_area :user, :favorite_books %>  <% end %>'
        else                      ''
      end
    end
  end
  
  # TODO: for testing templated attributes on existing records (where fields have non-nil values)
  def edit
  end
  
end





class TemplatedAttributeHelperTest < Test::Unit::TestCase

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  

  def test_text_area_with_templated_attribute_should_include_template_value
    get :new, :attribute => :bio
    assert_tag_innerHTML({:textarea => 'Tell us about yourself.'}, @response.body)
  end
  
  def test_text_area_with_templated_attribute_should_include_templated_js
    get :new, :attribute => :bio
    assert_tag_contains({:script => 'new TemplatedAttribute', :script => "'label', 'Tell us about yourself.'"}, @response.body)
  end

  def test_text_area_with_templated_attribute_with_js_disabled_should_not_include_templated_js
    get :new, :attribute => :bio_no_js
    assert !@response.body.include?('</script>')
  end

  def test_text_area_without_templated_attribute_should_have_no_value_when_nil
    get :new, :attribute => :favorite_books
    assert_tag_innerHTML({:textarea => ''}, @response.body)
  end

  def test_text_area_without_templated_attribute_should_not_include_templated_js
    get :new, :attribute => :favorite_books
    assert !@response.body.include?('</script>')
  end
  
  def test_short_form_style_should_produce_same_response_as_using_symbol_style
    get :new, :attribute => :bio
    symbol_form = @response.dup
    get :new, :attribute => :bio, :style => :short
    short_form = @response.dup
    assert_equal symbol_form.body, short_form.body
  end
  
  # TODO: lots more tests to write here
  
end
