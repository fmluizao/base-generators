module BaseGenerators
  module Generators
    class Base < Rails::Generators::Base #:nodoc:
      def self.source_root
        @_base_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'base_generators', generator_name, 'templates'))
      end

      def self.banner
        "#{$0} nifty:#{generator_name} #{self.arguments.map{ |a| a.usage }.join(' ')} [options]"
      end
    end
  end
end
