require 'base_generators'

module BaseGenerators
  module Generators
    class LayoutGenerator < Base
      argument :layout_name, :type => :string, :default => 'application', :banner => 'layout_name'
    
      def create_layout
        template  'layout.html.haml', "app/views/layouts/#{file_name}.html.haml"
        copy_file 'stylesheet.sass', "public/stylesheets/sass/#{file_name}.sass"
      end
      def create_helper
        copy_file 'base_helper.rb', 'app/helpers/base_helper.rb'
      end
      def copy_partials
        partial_views.each do |partial|
          copy_file "#{partial}.html.haml", "app/views/common/#{partial}.html.haml"  
        end
      end
    
    private
      
      def file_name
        layout_name.underscore
      end
      def partial_views
        %w[  
          _block
          _block_form
          _flashes
          _header
          _secondary_navigation
          _sidebar
        ]
      end
    end
  end
end
