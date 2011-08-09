module DynamicFields
  module Fields
    extend ActiveSupport::Concern
    
    included do
      # Set up the class attributes that must be available to all subclasses.
      class_inheritable_accessor :fields
      self.fields = []
      
      class_inheritable_accessor :indices
      self.indices = []
      
      
      delegate :fields, :indices, :to => "self.class"
    end
    
    module ClassMethods #:nodoc
      # Defines all the fields that are accessible on the model
      #
      # Options:
      #
      # name: The name of the field, as a +Symbol+.
      # options: A +Hash+ of options to supply to the +Field+.
      #
      # Example:
      #
      # <tt>field :score, :default => 0</tt>
      def field name, options = {}
        fields << ::DynamicFields::Field.new(name, options) unless field_names.include?(name.to_s)
      end
      
      # All field names (as defined in the model)
      def field_names
        fields.map(&:name).map(&:to_s)
      end
      
      # All pre-existing field names
      def real_field_names
        table_exists? ? column_names : []
      end
      
      # All pre-existing fields
      def real_fields
        return [] unless table_exists?
        columns.map do |c|
          next if c.primary == true
          ::DynamicFields::Field.new(c.name, :type => c.type, :default => c.default)
        end.compact
      end
      
      # Any fields which have not been add to the table
      def new_fields
        (self.fields ||= []).reject {|f| real_field_names.include?(f.name.to_s) }
      end
      
      # Any fields in the table, but not in the model
      def old_fields
        real_fields.reject { |f| field_names.include?(f.name.to_s) }
      end

      # Defines all the indices on the model
      #
      # Options:
      #
      # name: The name of the index, as a +String+.
      # options: A +Hash+ of options to supply to the +Index+.
      #
      # Example:
      #
      # <tt>index :user_id</tt>
      # <tt>index [:user_id, :user_group_id], :name => "user_groups", :unique => true</tt>
      def index field_or_fields, options={}
        options[:name] = options.delete(:as) || options.delete(:name) || connection.index_name(table_name, :column => field_or_fields)
        idx = ::DynamicFields::Index.new(field_or_fields, options)
        indices << idx unless index_ids.include?(idx.id)
      end
      
      # All index ids (as defined in the model)
      def index_ids
        indices.map(&:id)
      end
      
      # All pre-existing index ids
      def real_index_ids
        real_indices.map(&:id)
      end
      
      # All pre-existing indices
      def real_indices
        return [] unless table_exists?
        unless connection.respond_to?(:indexes)
          p "Dynamic indices not supported - remove old indices manually"
          return []
        else
          connection.indexes(table_name).map do |idx|
            idxs = idx.columns.size > 1 ? idx.columns : idx.columns.first
            ::DynamicFields::Index.new(idxs, {:name => idx.name, :unique => idx.unique})
          end.compact
        end
      end
      
      # Any indicies which have not been add to the table
      def new_indices
        (self.indices ||= []).reject { |idx| real_index_ids.include?(idx.id) }
      end
      
      # Any indices in the table, but not in the model
      def old_indices
        real_indices.reject { |idx| index_ids.include?(idx.id) }
      end
      
      # Check in the model requires a migration (any new or old fields/indices?) 
      def requires_migration?
        (new_fields + new_indices + old_fields + old_indices).any?
      end

      def migration_name
        return "create_#{table_name}" unless table_exists?
        "update_#{table_name}_" + [
          new_fields_migration_name, 
          new_indices_migration_name, 
          old_fields_migration_name, 
          old_indices_migration_name
        ].compact.join("_and_")
      end

      protected
        
        def new_fields_migration_name #:nodoc
          migration_name_for_collection new_fields, "add"
        end

        def old_fields_migration_name #:nodoc
          migration_name_for_collection old_fields, "remove"
        end
        
        def new_indices_migration_name #:nodoc
          new_migration_name = migration_name_for_collection(new_indices, "add_#{new_indices.size > 1 ? 'indices' : 'index'}")
          new_migration_name.present? ? new_migration_name.gsub("index_#{table_name}_on_", '') : nil
        end

        def old_indices_migration_name #:nodoc
          new_migration_name = migration_name_for_collection(old_indices, "remove_#{old_indices.size > 1 ? 'indices' : 'index'}")
          new_migration_name.present? ? new_migration_name.gsub("index_#{table_name}_on_", '') : nil
        end
        
        def migration_name_for_collection collection, prefix=nil #:nodoc
          new_migration_name = collection.map {|i| i.name.to_s }.to_sentence.gsub(/,?\W/, '_')
          new_migration_name.present? ? [prefix, new_migration_name].compact.join('_') : nil
        end

    end
  end
end