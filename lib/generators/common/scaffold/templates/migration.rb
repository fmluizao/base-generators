class Create<%= plural_class_name.gsub("::", "") %> < ActiveRecord::Migration
  def self.up
    create_table :<%= plural_name %>, :force => true do |t|
<% model_attributes.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>

      t.timestamps
    end
  end

  def self.down
    drop_table :<%= plural_name %>
  end
end
