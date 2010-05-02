require 'rails/generators/base'
 
module Common
  module Generators
    class Base < Rails::Generators::Base #:nodoc:
      def self.source_root
        @_common_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'common', generator_name, 'templates'))
      end
 
      def self.banner
        "#{$0} common:#{generator_name} #{self.arguments.map{ |a| a.usage }.join(' ')} [options]"
      end
    end
  end
end
