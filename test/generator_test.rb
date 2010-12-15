class RecursWidgetGeneratorTest < Rails::Generators::TestCase
  tests Recurs::WidgetGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  test "Assert all files are properly created" do
    arguments %w(event)
    run_generator
    assert_file "config/initializers/devise.rb"
    assert_file "config/locales/devise.en.yml"
  end

end