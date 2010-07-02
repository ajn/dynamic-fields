module DynamicFields
  class Index
    attr_reader :name, :fields, :options
    
    def initialize field_or_fields, options={}
      @fields  = field_or_fields   
      @name    = options[:name]
      @unique  = options.delete(:unique) == true
      @options = options
    end
    
    def id
      name
    end
    
    def to_s
      name
    end
    
    def unique?
      @unique == true
    end
   
    def migration_string_for table_state, action
      args = []
      case action = action.to_sym
      when :add
        args << (fields.is_a?(Array) ? fields : fields.to_sym).inspect
        args << ":name => #{name.inspect}" if fields.is_a?(Array)
        args << ":unique => true" if unique?
      when :remove
        args << fields.to_sym.inspect unless fields.is_a?(Array)
        args << ":name => #{name.to_sym.inspect}" if fields.is_a?(Array)
      end
      args.join(', ').gsub('\\', '')
    end
    
  end
  
end