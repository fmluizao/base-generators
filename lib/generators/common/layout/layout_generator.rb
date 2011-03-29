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
        template 'settings.yml', "config/settings.yml"
        template 'common.js', "public/javascripts/common.js"
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
        initializer('load_settings.rb', %q(APP_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml")).result)[Rails.env].symbolize_keys))
      end
    end
  end
end
