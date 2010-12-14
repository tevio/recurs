class RecursInstanceGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
  argument :name, :type => :string, :default => "event"

  def create_instance_model
    template "instance.rb.tmpl", "app/models/#{name}.rb"
    #create_file "app/models#{model_name}"
  end
end