class <%= plural_class_name %>Controller < InheritedResources::Base
  respond_to :html, :xml, :js, :json
protected
  def collection
    @search = end_of_association_chain.search(params[:search])
    @<%= collection_name %> ||= @search.paginate(:page => params[:page], :per_page => 10)
  end
end
