require 'rails/generators'

module DynamicFields
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    
    argument :model, :type => :string, :default => nil, :banner => "Model"

    def create_migration_file
      set_local_assigns!
      parse_attributes!
      migration_template "#{migration_action}_table.rb", "db/migrate/#{migration_name}.rb"
    end
    
    protected
      attr_reader :migration_action, :migration_klass, :table_name, :attributes, :migration_name
      
      def parse_attributes! #:nodoc:
        if migration_action == 'create'
          @attributes = migration_klass.new_fields
        else
          @attributes           = {}
          @attributes[:add]     = migration_klass.new_fields
          @attributes[:remove]  = migration_klass.old_fields
        end
      end

      def set_local_assigns!
        @migration_klass  = model.camelize.constantize
        @migration_action = @migration_klass.table_exists? ? 'update' : 'create'
        @table_name       = @migration_klass.table_name
        @migration_name   = @migration_klass.migration_name
      end
      
      # Set the current directory as base for the inherited generators.
      def self.base_root
        File.dirname(__FILE__)
      end

      def self.source_root
        File.expand_path(base_root + '/templates')
      end

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end
  end
end