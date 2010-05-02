require 'generators/common'

module Common
  module Generators
    class LayoutGenerator < Base
      argument :layout_name, 
        :type => :string, 
        :banner => 'Layout name', 
        :default => 'application'

      def copy_layout
        template 'layout.html.haml', "app/views/layouts/#{layout_name}.html.haml"
        template 'base_helper.rb', "app/helpers/#{layout_name}_helper.rb"
      end
      def copy_misc
        template 'bootstrap.rake', "lib/tasks/bootstrap.rake"
        template 'settings.yml', "config/settings.yml"
      end
      def copy_partials_to_common_directory
        %w(
          block
          header
          flashes
          secondary_navigation
          sidebar
        ).each do |partial|
          template "_#{partial}.html.haml", "app/views/common/_#{partial}.html.haml"
        end
      end
      def create_initializers
        template 'compass_config.rb', 'config/compass.rb'
        initializer('load_settings.rb', %q(APP_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml")).result)[Rails.env].symbolize_keys))
        initializer 'requires.rb', 
        %q{
Dir[File.join(Rails.root, 'lib', '*.rb')].each do |f|
  require f
end
        }
        
        initializer('compass.rb', %q(
# encoding: utf-8 
require 'compass'
rails_root = (defined?(Rails) ? Rails.root : Rails.root).to_s
Compass.add_project_configuration(File.join(rails_root, "config", "compass.rb"))
Compass.configure_sass_plugin!
Compass.handle_configuration_change!
        ))
      end
      def delete_unneeded_files
        run "rm README"
        run "rm public/index.html"
        run "rm public/favicon.ico"
        run "rm public/robots.txt"
        run "rm -f public/javascripts/*"

        run "cp config/database.yml config/database.yml.example"
        run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
        run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
      end
      def set_dependencies
        run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"
        run "curl -L http://github.com/malsup/form/raw/master/jquery.form.js?v2.40 > public/javascripts/jquery.form.js"
        run "curl -L http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js > public/javascripts/jquery-ui.js"
        run "curl -L http://github.com/brandonaaron/livequery/raw/master/jquery.livequery.js > public/javascripts/jquery.livequery.js"
        
        gem "inherited_resources", ">= 1.1.1"
        gem 'formtastic', :branch => 'rails3', :git => 'git://github.com/justinfrench/formtastic.git'
        gem "web-app-theme", :git => "git://github.com/lucasefe/web-app-theme.git"
        gem 'validation_reflection'
        gem 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :branch => 'rails3'
        gem 'show_for'
        gem "haml", "3.0.0.rc.2"
        gem 'compass', '0.10.0.rc4'
        gem 'compass-960-plugin'
                
        gem 'faker', :group => :test
        gem 'factory_girl', :group => :test
        gem 'capybara',         :git => 'git://github.com/jnicklas/capybara.git', :group => :test
        gem 'database_cleaner', :git => 'git://github.com/bmabey/database_cleaner.git', :group => :test
        gem 'cucumber-rails',   :git => 'git://github.com/aslakhellesoy/cucumber-rails.git', :group => :test
        
        in_root { run "bundle install" }

        generate("responders_install")
        generate("web_app_theme:theme --no-layout --theme=reidb-greenish")
        generate("formtastic:install")
      end
    end
  end
end
