require File.dirname(__FILE__) + '<%= spec_helper_path %>'

describe <%= class_name %> do
  subject { <%= class_name %>.new }
  it { should be_valid }
  <%- model_attributes.each do |f| -%>
  it { should respond_to(:<%= f.name %>)}
  <%- end -%>
end
