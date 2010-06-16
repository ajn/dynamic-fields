module DynamicFields
  module Fields
    extend ActiveSupport::Concern
    
    included do
      # Set up the class attributes that must be available to all subclasses.
      class_inheritable_accessor :fields

      self.fields = []
      delegate :fields, :to => "self.class"
    end
    
    module ClassMethods #:nodoc
      # Defines all the fields that are accessable on the model
      #
      # Options:
      #
      # name: The name of the field, as a +Symbol+.
      # options: A +Hash+ of options to supply to the +Field+.
      #
      # Example:
      #
      # <tt>field :score, :default => 0</tt>
      def field(name, options = {})
        self.fields << ::DynamicFields::Field.new(name, options) unless self.field_names.include?(name.to_s)
      end

      def field_names
        fields.map(&:name).map(&:to_s)
      end

      def new_fields
        table_exists? ? fields.reject {|f| column_names.include?(f.name.to_s) } : fields
      end

      def old_fields
        table_exists? ?
          columns.map do |c| 
            next if field_names.include?(c.name.to_s) || c.primary == true
            ::DynamicFields::Field.new(c.name, :type => c.type, :default => c.default)
          end.compact : []
      end

      def requires_migration?
        (new_fields + old_fields).any?
      end

      def migration_name
        return "create_#{table_name}" unless table_exists?
        "update_#{table_name}_" + [new_fields_migration_name, old_fields_migration_name].compact.join("_and_")
      end

      protected

        def new_fields_migration_name
          new_fields_name = new_fields.map {|f| f.name.to_s }.to_sentence.gsub(/,?\W/, '_')
          new_fields_name.present? ? "add_#{new_fields_name}" : nil
        end

        def old_fields_migration_name
          old_fields_name = old_fields.map {|f| f.name.to_s }.to_sentence.gsub(/,?\W/, '_')
          old_fields_name.present? ? "remove_#{old_fields_name}" : nil
        end

    end
  end
end