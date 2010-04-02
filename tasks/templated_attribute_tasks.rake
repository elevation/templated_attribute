namespace :templated_attribute do
  
  PLUGIN_ROOT = File.dirname(__FILE__) + '/../'
  
  desc "Installs the plugin's javascripts and stylesheets in the public directory"
  task :install do
    puts "Adding templated_attribute's javascripts and stylesheets..."
    FileUtils.cp Dir[PLUGIN_ROOT + '/assets/*.js'], RAILS_ROOT + '/public/javascripts'
    puts '+ public/javascripts/templated_attribute.js'
    FileUtils.cp Dir[PLUGIN_ROOT + '/assets/*.css'], RAILS_ROOT + '/public/stylesheets'
    puts '+ public/stylesheets/templated_attribute.css'
  end
  
  desc "Removes the plugin's javascripts and stylesheets from the public directory"
  task :remove do
    puts "Removing templated_attribute's javascripts and stylesheets..."
    FileUtils.rm RAILS_ROOT + '/public/javascripts/templated_attribute.js'
    puts '- public/javascripts/templated_attribute.js'
    FileUtils.rm RAILS_ROOT + '/public/stylesheets/templated_attribute.css'
    puts '- public/stylesheets/templated_attribute.css'
  end
  
end
