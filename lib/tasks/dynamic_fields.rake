require 'dynamic_fields/migration_generator'

namespace :dynamic_fields do
  
  desc "Generate a migration for the specified MODEL"
  task :migration => :environment do
    klass = ENV["MODEL"].classify.constantize
    if klass.requires_migration?
      puts "Generating a migration for #{klass.name}"
      DynamicFields::MigrationGenerator.start klass.name
    else
      puts "#{klass.name} is up to date!"
    end
  end
  
  desc "Generate migrations for all Models"
  task :migrations => :load_models do
    DynamicFields.models.each do |model|
      ENV['MODEL'] = model.name
      Rake::Task['df:migration'].invoke
    end
  end

  desc "Generate migrations for all Models and migrate the database"
  task :migrate => :migrations do
    Rake::Task['db:migrate'].invoke
  end

  task :load_models => :environment do
    Dir["#{Rails.root}/app/models/**/*.rb"].each { |model| require_or_load model }
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
