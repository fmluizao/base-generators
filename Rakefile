# Rakefile
require 'rubygems'
require 'rake'

# require 'echoe'
# Echoe.new('base-generators', '0.1.0') do |p|
#   p.summary        = "Rails Generators using SearchLogic, Formtastic, jquery and many more."
#   p.description    = "BaseGenerators tries to ease the pain of starting a new app from scratch by automating tasks with generators."
#   p.url            = "http://github.com/lucasefe/base-generators"
#   p.author         = "Lucas Efe"
#   p.email          = "lucasefe@gmail.com"
#   p.ignore_pattern = ["tmp/*", "script/*"]
#   p.development_dependencies = []
# end
# 

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "base-generators"
    gemspec.summary        = "Rails Generators using SearchLogic, Formtastic, jquery and many more."
    gemspec.description    = "BaseGenerators tries to ease the pain of starting a new app from scratch by automating tasks with generators."
    gemspec.homepage            = "http://github.com/lucasefe/base-generators"
    gemspec.authors         = ["Lucas Efe"]
    gemspec.email          = "lucasefe@gmail.com"
    # This doesn't belong here
    # gemspec.add_dependency('searchlogic', '>= 2.4.19')
    # gemspec.add_dependency('inherited_resources', '= 1.0.6')
    # gemspec.add_dependency('formtastic','= 0.9.8')
    # gemspec.add_dependency('validation_reflection','= 0.3.6')
    # gemspec.add_dependency('show_for','= 0.1.3')
    # gemspec.add_dependency('will_paginate','= 2.3.12')
    # gemspec.add_dependency('haml','3.0.0.rc.2')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler -s http://gemcutter.org"
end



Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

