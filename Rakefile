# Rakefile
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('base-generators', '0.1.0') do |p|
  p.summary        = "Rails Generators using SearchLogic, Formtastic, jquery and many more."
  p.description    = "BaseGenerators tries to ease the pain of starting a new app from scratch by automating tasks with generators."
  p.url            = "http://github.com/lucasefe/base-generators"
  p.author         = "Lucas Efe"
  p.email          = "lucasefe@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

