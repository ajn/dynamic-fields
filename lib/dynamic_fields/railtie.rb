require 'dynamic_fields'
require 'rails'
module DynamicFields
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/dynamic_fields.rake"
    end
  end
end