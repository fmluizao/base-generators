# Basado en el scaffold generator de Resource Controller.
class BaseScaffoldGenerator < Rails::Generator::NamedBase
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name,
                :resource_edit_path,
                :default_file_extension,
                :generator_default_file_extension
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super
    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    generator_default_file_extension = "haml"
    default_file_extension = "html.#{generator_default_file_extension}"
    record do |m|
      m.class_collisions(class_path, "#{class_name}")

      # Controller, helper, views, and test directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))

      scaffold_views.each do |action|
        m.template(
          "view_#{action}.#{generator_default_file_extension}",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.#{default_file_extension}")
        )
      end
      m.template("view__collection.#{generator_default_file_extension}",
        File.join('app/views', controller_class_path, controller_file_name, "_#{plural_name}.#{default_file_extension}" ))
      m.template("view_index.js.#{generator_default_file_extension}",
        File.join('app/views', controller_class_path, controller_file_name, "index.js.#{generator_default_file_extension}" ))


      m.template('model.rb', File.join('app/models', class_path, "#{file_name}.rb"))
      m.template('controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb"))
      m.template('helper.rb', File.join('app/helpers', controller_class_path, "#{controller_file_name}_helper.rb"))

      m.template('common.js', 'public/javascripts/common.js')

      unless options[:skip_migration]
        migration_template = 'migration.rb'
        
        m.migration_template(
          migration_template, 'db/migrate', 
          :assigns => {
            :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}",
            :attributes     => attributes
          }, 
          :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
        )
      end

      m.route_resources controller_file_name
    end
  end
  
  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} scaffold_for ModelName [field:type, field:type]"
    end

    def basic_views
      %w[ index show new edit ]
    end
    
    def scaffold_views
      basic_views + %w[ _form _search ]
    end

    def model_name 
      class_name.demodulize
    end

    # def add_options!(opt)
    #   opt.separator ''
    #   opt.separator 'Options:'
    #   opt.on("--rspec", "Force rspec mode (checks for RAILS_ROOT/spec by default)") { |v| options[:rspec] = true }
    # end
end

module Rails
  module Generator
    class GeneratedAttribute
      def default_value
        @default_value ||= case type
          when :int, :integer               then "\"1\""
          when :float                       then "\"1.5\""
          when :decimal                     then "\"9.99\""
          when :datetime, :timestamp, :time then "Time.now"
          when :date                        then "Date.today"
          when :string                      then "\"MyString\""
          when :text                        then "\"MyText\""
          when :boolean                     then "false"
          else
            ""
        end      
      end
      def default_options
        case type
        when :decimal
          ", :precision => 8, :scale => 2"
        else
          ""
        end
      end
      def input_type
        @input_type ||= case type
          when :text                        then "textarea"
          when :boolean                     then "check_box"
          else
            "input"
        end      
      end
    end
  end
end
