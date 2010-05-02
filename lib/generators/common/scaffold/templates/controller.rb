class <%= plural_class_name %>Controller < InheritedResources::Base
  respond_to :html, :xml, :js, :json
protected
  def collection
    @<%= collection_name %> ||= <%= class_name %>.paginate(:page => params[:page], :per_page => 10)
  end
end
