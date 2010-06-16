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
  
  end
end