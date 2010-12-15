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
    template "views/#{v}", "app/views/#{name.downcase.pluralize}/#{v}.html.haml"
    }
    ['_monthly', '_set_points', '_standard', '_weekly'].each {|v|
    template "views/schemes/#{v}", "app/views/#{name.downcase.pluralize}/schemes/#{v}.html.haml"
    }
  end

  def create_instance_route
    #insert_into_file 'config/routes.rb'
  end

  def create_instance_controller

  end

end
#end