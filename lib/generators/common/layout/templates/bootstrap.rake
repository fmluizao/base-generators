namespace :app do
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