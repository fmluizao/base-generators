# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{base-generators}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lucas Efe"]
  s.date = %q{2010-04-26}
  s.description = %q{BaseGenerators tries to ease the pain of starting a new app from scratch by automating tasks with generators.}
  s.email = %q{lucasefe@gmail.com}
  s.extra_rdoc_files = ["README.textile", "tasks/scaffold_it_tasks.rake"]
  s.files = ["MIT-LICENSE", "README.textile", "Rakefile", "VERSION", "generators/base_bootstrap/base_bootstrap_generator.rb", "generators/base_bootstrap/templates/_block.html.haml", "generators/base_bootstrap/templates/_block_form.html.haml", "generators/base_bootstrap/templates/_flashes.html.haml", "generators/base_bootstrap/templates/_header.html.haml", "generators/base_bootstrap/templates/_secondary_navigation.html.haml", "generators/base_bootstrap/templates/_sidebar.html.haml", "generators/base_bootstrap/templates/base_helper.rb", "generators/base_bootstrap/templates/layout.html.haml", "generators/base_scaffold/base_scaffold_generator.rb", "generators/base_scaffold/templates/common.js", "generators/base_scaffold/templates/controller.rb", "generators/base_scaffold/templates/helper.rb", "generators/base_scaffold/templates/migration.rb", "generators/base_scaffold/templates/model.rb", "generators/base_scaffold/templates/view__collection.haml", "generators/base_scaffold/templates/view__form.haml", "generators/base_scaffold/templates/view__search.haml", "generators/base_scaffold/templates/view_edit.haml", "generators/base_scaffold/templates/view_index.haml", "generators/base_scaffold/templates/view_index.js.haml", "generators/base_scaffold/templates/view_new.haml", "generators/base_scaffold/templates/view_show.haml", "rails/init.rb", "rails_template.rb", "tasks/scaffold_it_tasks.rake", "test/scaffold_it_test.rb", "test/test_helper.rb", "uninstall.rb", "Manifest", "base-generators.gemspec"]
  s.homepage = %q{http://github.com/lucasefe/base-generators}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Base-generators", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{base-generators}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Rails Generators using SearchLogic, Formtastic, jquery and many more.}
  s.test_files = ["test/scaffold_it_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
