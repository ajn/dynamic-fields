require 'active_support'
require 'rails/generators/base'

module DynamicFields  
  extend ActiveSupport::Concern
  included do
    include Fields
  end
  
  def self.models
    ActiveRecord::Base.subclasses.select do |ar|
      ar.included_modules.include?(DynamicFields)
    end
  end

end

require 'dynamic_fields/field'
require 'dynamic_fields/index'
require 'dynamic_fields/fields'
require 'dynamic_fields/railtie'