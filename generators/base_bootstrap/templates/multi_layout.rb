# Multi-layout
# Multi-helper
module MultiLayout
  module ViewHelpers
    mattr_accessor :default_secondary_navigation_path
    @@default_secondary_navigation_path = 'common/secondary_navigation'
    def show_content_if(content, &block)
      if content.present?
        yield(content)
      end
    end
    def sidebar_link(name, options = {}, html_options = nil)
      content_tag(:li, link_to(name, options, html_options))
    end
    def navigation_block(nav = nil)
      render(:partial => (nav||@@default_secondary_navigation_path))
    end
    def flashes
      render :partial => 'common/flashes'
    end
    def block(title, options = {}, &block)
      content = capture(&block)
      out = render :partial => 'common/block', :locals => { 
        :title => title, 
        :content => content, 
        :options => options
      }
      concat out
    end
    def block_form(title, &block)
      content = capture(&block)
      out = render :partial => 'common/block_form', :locals => { :title => title, :content => content}
      concat out
    end
  private
  end
end

ActionView::Base.send :include, MultiLayout::ViewHelpers