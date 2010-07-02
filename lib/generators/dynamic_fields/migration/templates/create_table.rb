class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
<% attributes.each do |attribute| -%>
      t.<%= attribute.type %> <%= attribute.migration_string_for :create, :add %>
<% end -%>
    end
    
<% indices.each do |index| -%>
    add_index :<%= table_name %>, <%= index.migration_string_for :create, :add %>
<% end -%>
  end

  def self.down
<% indices.each do |index| -%>
    remove_index :<%= table_name %>, <%= index.migration_string_for :create, :remove %>
<% end -%>
    drop_table :<%= table_name %>
  end
end
