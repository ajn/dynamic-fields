class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up<% attributes.each do |action, attrs| %><% attrs.each do |attribute| %>
    <%= action %>_column :<%= table_name %>, :<%= attribute.name %><% if action == :add %>, :<%= attribute.type %><% if attribute.default %>, :default => <%= attribute.default %><% end -%><% end -%>
  <% end %><% end %>
  end

  def self.down<% attributes.each do |action, attrs| %><% attrs.reverse.each do |attribute| %>
    <%= action == :add ? 'remove' : 'add' %>_column :<%= table_name %>, :<%= attribute.name %><% if action == :remove %>, :<%= attribute.type %><% if attribute.default %>, :default => <%= attribute.default %><% end -%><% end -%>
  <% end %><% end %>
  end
end
