# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm -f public/javascripts/*"
file 'public/javascripts/application.js', ''
# Set up git repository
git :init

# Copy database.yml for distribution use
run "cp config/database.yml config/database.yml.example"
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

gem 'ruby-openid', :lib => 'openid'
gem 'inherited_resources', :source => 'http://gemcutter.org'
gem 'formtastic', :source => 'http://gemcutter.org'
gem 'web-app-theme', :source => 'http://gemcutter.org', :lib => false
gem 'haml'
gem 'searchlogic', :version => '~> 2.3.6'
gem 'validation_reflection'
gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'

# Testing 
gem 'rspec', :lib => false
gem 'rspec-rails', :lib => false
gem 'remarkable_rails', :lib => false
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'

rake("gems:install", :sudo => true)

plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'
plugin 'jrails', :git => "git://github.com/aaronchi/jrails.git"
plugin 'hoptoad_notifier', :git => "git://github.com/thoughtbot/hoptoad_notifier.git"
plugin 'base-generators', :git => "git://github.com/lucasefe/base-generators.git"

# Download JQuery
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"
run "curl -L http://jquery.malsup.com/form/jquery.form.js?2.36 > public/javascripts/jquery.form.js"
run "curl -L http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js > public/javascripts/jquery-ui.js"
run "curl -L http://github.com/aaronchi/jrails/raw/master/javascripts/jrails.js > public/javascripts/jrails.js"
run "curl -L http://github.com/brandonaaron/livequery/raw/master/jquery.livequery.js > public/javascripts/jquery.livequery.js"

rake('db:sessions:create')
initializer 'session_store.rb', <<-END
ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
ActionController::Base.session_store = :active_record_store
END
initializer 'hoptoad.rb', 
%q{HoptoadNotifier.configure do |config|
  config.api_key = 'HOPTOAD-KEY'
end
}
initializer 'requires.rb', 
%q{Dir[File.join(RAILS_ROOT, 'lib', '*.rb')].each do |f|
  require f
end
}
initializer 'load_settings.rb', %q(APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/settings.yml")[RAILS_ENV].symbolize_keys)
file 'config/settings.yml', %q(
development: &non_production_settings
  site_name: App From Hell!
  admin_email: some@example.com
  
test:
  <<: *non_production_settings

staging:
  <<: *non_production_settings
    
production:
  <<: *non_production_settings
)
capify!

file 'config/deploy.rb', 
%q{set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

before "deploy:setup", "db:password"

  desc "Run this after every successful deployment" 
  task :after_default do
    cleanup
  end
end

namespace :db do
  desc "Create database password in shared path" 
  task :password do
    set :db_password, Proc.new { Capistrano::CLI.password_prompt("Remote database password: ") }
    run "mkdir -p #{shared_path}/config" 
    put db_password, "#{shared_path}/config/dbpassword" 
  end
end
}

file 'config/deploy/staging.rb', 
%q{# For migrations
set :rails_env, 'staging'

# Who are we?
set :application, 'CHANGEME'
set :repository, "git@192.168.101.154:/var/git/#{application}.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :branch, "staging"

# Where to deploy to?
role :web, "staging.example.com"
role :app, "staging.example.com"
role :db,  "staging.example.com", :primary => true

# Deploy details
set :user, "#{application}"
set :deploy_to, "/var/apps/#{application}"
set :use_sudo, false
set :checkout, 'export'
}

file 'config/deploy/production.rb', 
%q{# For migrations
set :rails_env, 'production'

# Who are we?
set :application, 'CHANGEME'
set :repository, "git@192.168.101.154:/var/git/#{application}.git"
set :scm, "git"
set :deploy_via, :remote_cache

set :branch, "production"

# Where to deploy to?
role :web, "production.example.com"
role :app, "production.example.com"
role :db,  "production.example.com", :primary => true

# Deploy details
set :user, "#{application}"
set :deploy_to, "/var/apps/#{application}"
set :use_sudo, false
set :checkout, 'export'
}

# Commit all work so far to the repository
git :add => '.'
git :commit => "-a -m 'Initial commit'"

generate("base_bootstrap application")
generate("rspec")
generate("theme --no-layout --theme=reidb-greenish")
generate("formtastic")
file 'public/stylesheets/formtastic_changes.css', 
%q(form.formtastic.search fieldset {
  margin-bottom:  0.5em;
}

form.formtastic.search fieldset legend {
  font-size: 1.3em;
  margin-bottom: 0.5em;
}
form.formtastic.search  {
  background-color: #F1F1F1;
  display: none;
  padding: .5em;
  margin-bottom:  0.5em;
}
.actions {
  margin-bottom: 1em;
}
)
file 'lib/tasks/bootstrap.rake',
%q(namespace :app do
  namespace :development do
    desc "Resets the environment!"
    task :reset => [ "db:drop", "db:create", "db:migrate", :bootstrap ]
    desc "Bootstrap"
    task :bootstrap => [ :environment ]
  end
  namespace :staging do
    desc "Resets the environment!"
    task :reset => [ "db:drop", "db:create", "db:migrate", :bootstrap ]
    desc "Bootstrap"
    task :bootstrap => [ :environment ]
  end
  namespace :production do
    desc "Resets the environment!"
    task :reset => [ "db:drop", "db:create", "db:migrate", :bootstrap ]
    desc "Bootstrap"
    task :bootstrap => [ :environment ]
  end
end

desc "Alias de app:development:reset"
task :adr => [ "app:development:reset" ]
)
# Success!
puts "Initial Commit!"
