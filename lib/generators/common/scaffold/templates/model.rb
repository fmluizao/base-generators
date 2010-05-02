class <%= class_name %> < ActiveRecord::Base
<%- unless model_attributes.empty? -%>
  attr_accessible <%= model_attributes.map { |a| ":#{a.name}" }.join(", ") %>
<%- end -%>
end
