class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up<% attributes.each do |action, attrs| %><% attrs.each do |attribute| %>
    <%= action %>_column :<%= table_name %>, <%= attribute.migration_string_for :update, action %><% end -%>
  <% end %><% indices.each do |action, idxs| %><% idxs.each do |index| %>
    <%= action %>_index :<%= table_name %>, <%= index.migration_string_for :update, action %><% end -%>
  <% end %>
  end

  def self.down<% indices.each do |action, idxs| %><% idxs.each do |index| %>
    <%= action == :add ? 'remove' : 'add' %>_index :<%= table_name %>, <%= index.migration_string_for(:update, action == :add ? :remove : :add ) %><% end -%>
  <% end %><% attributes.each do |action, attrs| %><% attrs.reverse.each do |attribute| %>
    <%= action == :add ? 'remove' : 'add' %>_column :<%= table_name %>, <%= attribute.migration_string_for(:update, action == :add ? :remove : :add ) %><% end -%>
  <% end %>
  end
end
