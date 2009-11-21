# Basado en el scaffold generator de Resource Controller.
class BaseBootstrapGenerator < Rails::Generator::NamedBase
  def initialize(runtime_args, runtime_options = {})
    super
    @layout_name = @name.underscore
  end

  def manifest
    record do |m|
      m.directory(File.join('app/views/layouts'))
      m.directory(File.join('app/views/common'))
      m.directory(File.join('app/helpers'))
      
      templates = File.join([File.dirname(__FILE__), "templates"])
      Dir.glob(File.join([templates, "_*.html.haml"])).each do |html|
        html_basename = File.basename(html)
        m.file(html_basename, "app/views/common/#{html_basename}")
      end
      m.file("layout.html.haml", "app/views/layouts/#{@layout_name}.html.haml")
      m.file("base_helper.rb", "app/helpers/base_helper.rb")
    end
  end
  
  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} base_bootstrap application"
    end
end