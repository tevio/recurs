#module
class RecursWidgetGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
  argument :name, :type => :string, :default => "event"

  def create_instance_model
    template "instance.rb.tmpl", "app/models/#{name.downcase}.rb"
    #create_file "app/models#{model_name}"
  end

  def create_instance_views
    ['index', 'show', 'edit', 'new', '_form'].each {|v|
    template "views/#{v}", "app/views/#{name.downcase}s/#{v}.html.haml"
    }
    ['_monthly', '_set_points', '_standard', '_weekly'].each {|v|
    template "views/schemes/#{v}", "app/views/#{name.downcase}s/schemes/#{v}.html.haml"
    }
  end

  def create_instance_route
    #insert_into_file 'config/routes.rb', "resources :#{name.downcase}s", :after => "Application.routes.draw do\n"
  end

  def create_instance_controller
    template "controller.rb.tmpl", "app/controllers/#{name.downcase}s_controller.rb"
  end

end
#end