# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dynamic-fields}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Neill"]
  s.date = %q{2010-07-02}
  s.description = %q{Allows for automatic migrations with ActiveRecord}
  s.email = %q{alex@featureless.co.uk}
  s.files = [
    "lib/dynamic_fields.rb",
     "lib/dynamic_fields/field.rb",
     "lib/dynamic_fields/fields.rb",
     "lib/dynamic_fields/index.rb",
     "lib/dynamic_fields/migration_generator.rb",
     "lib/dynamic_fields/railtie.rb",
     "lib/generators/dynamic_fields/migration/USAGE",
     "lib/generators/dynamic_fields/migration/migration_generator.rb",
     "lib/generators/dynamic_fields/migration/templates/create_table.rb",
     "lib/generators/dynamic_fields/migration/templates/update_table.rb",
     "lib/tasks/dynamic_fields.rake"
  ]
  s.homepage = %q{http://github.com/ajn/dynamic-fields}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Auto-migrate ActiveRecord models}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

