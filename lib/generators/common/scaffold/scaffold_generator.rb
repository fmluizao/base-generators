require 'generators/common'
require 'rails/generators/migration'
require 'rails/generators/generated_attribute'

module Common
  module Generators
    class ScaffoldGenerator < Base
      include Rails::Generators::Migration
      no_tasks { attr_accessor :model_name, :model_attributes, :controller_actions }

      class_option :skip_model, :desc => 'Don\'t generate a model or migration file.', :type => :boolean
      class_option :skip_controller, :desc => 'Don\'t generate controller, helper, or views.', :type => :boolean
      class_option :skip_migration, :desc => 'Dont generate migration file for model.', :type => :boolean
      
      argument :model_name, :type => :string, :required => true, :banner => 'ModelName'
      argument :args_for_c_m, :type => :array, :default => [], :banner => 'controller_actions and model:attributes'
      
      # complete:scaffold Admin:User login:string email:string time_zone:string 
      
      def initialize(*args, &block)
        super
        @controller_actions = []
        args_for_c_m.each do |arg|
          if arg == '!'
            options[:invert] = true
          elsif arg.include?(':')
            model_attributes << Rails::Generators::GeneratedAttribute.new(*arg.split(':'))
          else
            @controller_actions << arg
            @controller_actions << 'create' if arg == 'new'
            @controller_actions << 'update' if arg == 'edit'
          end
        end
        if options.invert? || @controller_actions.empty?
          @controller_actions = all_actions - @controller_actions
        end
      end
      def create_model
        unless options.skip_model?
          template 'model.rb', "app/models/#{singular_name_path}.rb"
          template "rspec/model.rb", "spec/models/#{singular_name_path}_spec.rb"
        end
      end
      def create_controller
        unless options.skip_controller?
          template 'controller.rb', "app/controllers/#{plural_name_path}_controller.rb"
          template 'helper.rb', "app/helpers/#{plural_name_path}_helper.rb"
        end
      end
      def create_views
        unless options.skip_controller?
          @controller_actions.each do |action|
            if %w[index show new edit].include?(action) # Actions with templates
              template "views/#{action}.html.haml", "app/views/#{plural_name_path}/#{action}.html.haml"
            end
          end
          template "views/index.js.haml", "app/views/#{plural_name_path}/index.js.haml"
          template "views/_form.html.haml", "app/views/#{plural_name_path}/_form.html.haml"
          template "views/_search.html.haml", "app/views/#{plural_name_path}/_search.html.haml"
          template "views/_collection.html.haml", "app/views/#{plural_name_path}/_#{collection_name}.html.haml"
          route "resources #{plural_name.to_sym.inspect}"
        end
      end
      def create_migrations
        unless options.skip_model? || options.skip_migration?
          migration_template 'migration.rb', "db/migrate/create_#{plural_name}.rb"
        end
      end

    private
      def namespaced?
        class_name.include?("::")
      end
      # Admin::User
      def class_name
        model_name.camelize
      end
      def plural_class_name
        class_name.pluralize
      end
      # admin/user
      def singular_name_path
        model_name.gsub("::", "/").underscore
      end
      # user
      def singular_name
        singular_name_path.gsub("/", "_")
      end
      # admin/users
      def plural_name
        singular_name.pluralize
      end
      # users
      def plural_name_path
        singular_name_path.pluralize
      end
      def instance_name
        model_name.split("::").last.underscore
      end
      def collection_name
        instance_name.pluralize
      end
      def model_attributes
        @model_attributes ||= []
      end
      def all_actions
        %w[ index show new create edit update destroy ]
      end
      def all_partials
        %w[  _collection ]
      end
      def spec_helper_path
        "/.." * class_name.split("::").size + 'spec_helper'
      end
      def self.next_migration_number(dirname) #:nodoc:
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
end
