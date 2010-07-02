module DynamicFields
  class Field
    attr_reader :name, :type, :type_class, :default, :options
    # Create the new field with a name and optional additional options. Valid
    # options are :default
    #
    # Options:
    #
    # name: The name of the field as a +Symbol+.
    # options: A +Hash+ of options for the field.
    #
    # Example:
    #
    # <tt>Field.new(:score, :default => 0)</tt>
    def initialize(name, options = {})
      @name, @default = name, options.delete(:default)
      @type = options.delete(:type) || :string
      @options = options
    end
    
    def options_with_default
      has_default? ? options.merge(:default => default) : options
    end
    
    def has_default?
      default.present? || default == false || default == ''
    end
    
    def migration_string_for table_state, action
      args = [name.to_sym.inspect]
      if action.to_sym == :add
        args << type.inspect if table_state.to_sym == :update
        args += options_with_default.map do |k, v|
          "#{k.to_sym.inspect} => #{v.inspect}"
        end
      end
      args.join(', ').gsub('\\', '')
    end

  end
end