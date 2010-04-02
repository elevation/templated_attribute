/* Javascript for templated_attribute plugin */


/* TemplatedAttribute class
   ========================
   This class encapsulates the frontend user experience for the templated_attribute
   plugin. For each instantiation of this object with a form element and its template value,
   the object will register event listeners to monitor the field's contents and style it
   appropriately. If the field contains the template value, it will have a gray text color
   to imply that the value is a "template" for real data. If not, it will be styled normally.
   Also, if the user empties the field completely, the object will restore the template value
   and the gray text color. For 'label' template types, we also register the focus event to
   clear the template value on click/focus.

   Usage:
   Event.observe(window, 'load', function() {
     t = new TemplatedAttribute($('user_website'), 'starting_value', 'http://');
   });
*/
var TemplatedAttribute = Class.create();
TemplatedAttribute.prototype = {
  
  // define this class for input elements in CSS
  css_class: 'templated_attribute',
  
  initialize: function(element, template_type, template_value) {
    this.element = element;
    this.template_type = template_type;
    this.template_value = template_value;
    
    // load template styling into possibly-templated fields initially
    this.initStyles();
    
    // register listeners for keyUp and blur to monitor changes to the field;
    // also register focus for 'label' template types
    Event.observe(element, 'keyup', this.keyUp.bindAsEventListener(this));
    Event.observe(element, 'blur', this.blur.bindAsEventListener(this));
    if (this.template_type == 'label') {
      Event.observe(element, 'focus', this.focus.bindAsEventListener(this));
    }
  },
  
  // initStyles: check for existing template values and style them correctly
  initStyles: function() {
    this.keyUp();  // happens to be the same code
  },

  // keyup: if the field's value is the template value, style it correctly
  keyUp: function() {
    if (this.element.value.strip() == this.template_value) { 
      this.element.addClassName(this.css_class);
    } else {
      this.element.removeClassName(this.css_class);
    }
  },
  
  // blur: if the user blanked the field, put the template value back and style
  // it. also take care of situations where template value is already there but
  // needs to be styled correctly (e.g. from the browser leaving form values
  // after a refresh)
  blur: function() {
    current_value = this.element.value.strip();
    if (current_value == '' || current_value == this.template_value) {
      this.element.addClassName(this.css_class);
      this.element.value = this.template_value;
    }
  },
  
  // focus: if the user switches focus to the field and it contains the template
  // value, blank it out so the user can enter valid data. only used with 'label'
  // template type.
  focus: function() {
    current_value = this.element.value.strip();
    if (current_value == this.template_value) {
      this.element.value = '';
      this.element.removeClassName(this.css_class);
    }
  }
}

