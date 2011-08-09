class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
<%- attributes[:add].each do |attribute| -%>
    add_column :<%= table_name %>, <%= attribute.migration_string_for :update, :add %>
<%- end -%><%- indices[:add].each do |index| -%>
    add_index :<%= table_name %>, <%= index.migration_string_for :update, :add %>
<%- end -%><%- indices[:remove].each do |index| -%>
    remove_index :<%= table_name %>, <%= index.migration_string_for :update, :remove %>
<%- end -%><%- attributes[:remove].each do |attribute| -%>
    remove_column :<%= table_name %>, <%= attribute.migration_string_for :update, :remove %>
<%- end -%>
  end

  def self.down
<%- indices[:add].reverse.each do |index| -%>
    remove_index :<%= table_name %>, <%= index.migration_string_for :update, :remove %>
<%- end -%><%- attributes[:add].reverse.each do |attribute| -%>
    remove_column :<%= table_name %>, <%= attribute.migration_string_for :update, :remove %>
<%- end -%><%- attributes[:remove].reverse.each do |attribute| -%>
    add_column :<%= table_name %>, <%= attribute.migration_string_for :update, :add %>
<%- end -%><%- indices[:remove].reverse.each do |index| -%>
    add_index :<%= table_name %>, <%= index.migration_string_for :update, :add %>
<%- end -%>
  end
end
