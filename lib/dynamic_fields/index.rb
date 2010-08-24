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
      name.to_s
    end
    
    def unique?
      @unique == true
    end
   
    def migration_string_for table_state, action
      args = []
      case action = action.to_sym
      when :add
        args << (fields.is_a?(Array) ? fields : fields.to_sym).inspect
        args << ":name => #{to_s.inspect}"
        args << ":unique => true" if unique?
      when :remove
        args << ":name => #{to_s.inspect}"
      end
      args.join(', ').gsub('\\', '')
    end
    
  end
  
end