require 'dynamic_fields/migration_generator'

namespace :dynamic_fields do
  
  desc "Generate a migration for the specified MODEL"
  task :migration => :environment do
    generate_migration_for ENV["MODEL"].classify.constantize
  end
  
  desc "Generate migrations for all Models"
  task :migrations => :load_models do
    DynamicFields.models.each do |model|
      generate_migration_for model
    end
  end

  desc "Generate migrations for all Models and migrate the database"
  task :migrate => :migrations do
    Rake::Task['db:migrate'].invoke
  end

  task :load_models => :environment do
    Dir["#{Rails.root}/app/models/**/*.rb"].each { |model| require_or_load model }
    Rails::Engine.subclasses.each do |engine|
      engine_load_path = engine.paths.app.models.paths.first
      Dir[engine_load_path + '/*.rb', engine_load_path + '/**/*.rb'].each { |model| require_or_load model rescue LoadError }
    end
  end

end

namespace :df do
  desc "Generate a migration for the specified MODEL"
  task :migration => "dynamic_fields:migration"
  desc "Generate migrations for all Models"
  task :migrations => "dynamic_fields:migrations"
  desc "Generate migrations for all Models and migrate the database"
  task :migrate => "dynamic_fields:migrate"
end

def generate_migration_for(klass)
  return unless klass.name.present? # no annoymous classes
  if klass.requires_migration?
    puts "Generating a migration for #{klass.name}"
    DynamicFields::MigrationGenerator.start klass.name
  else
    puts "#{klass.name} is up to date!"
  end
end