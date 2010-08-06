module TableBuilderHelper
  
  class TableColumn
    
    include ActionView::Helpers::TagHelper

    attr_reader :options
    
    SORTABLE_CLASS = 'sortable'
    
    def initialize(options, cell_contents_block, view)
      @options = options
      @cell_contents_block = cell_contents_block
      @view = view
    end
    
    def contents_for(item)
      @view.capture(item, &@cell_contents_block)
    end
    
    # Sorting
    
    def order
      in_order  = options[:order]
      unordered = options[:unordered]
      
      if in_order == nil
        [ 2, unordered ]
      elsif in_order >= 0
        [ 1, in_order ]
      else # if in_order < 0
        [ 3, in_order ]
      end
    end
    
    def <=>(other)
      order <=> other.order
    end
    
    ###################
    #                 #
    # Builder Methods #
    #                 #
    ###################
    
    def header_options
      styles = []
      styles << 'display: none'              if options[:hidden]
      
      Hash.new.tap do |opts|
        opts[:style] = styles.join('; ') unless styles.empty?
        
        css_classes = []
        css_classes << options[:css_class] if options[:css_class]
        opts[:class] = css_classes.join(' ') unless css_classes.empty?
      end
    end
    
    def header_cell(html, page_requester)
      html.th(header_options) do
        if options[:sortable]
          href = (options[:sortable] == page_requester.current_order) ? page_requester.for_toggled_ascending : page_requester.for_order( options[:sortable] )
          css_class = SORTABLE_CLASS
          css_class += ' ' + page_requester.current_ascending_css_class if options[:sortable] == page_requester.current_order
          
          html.a :href => href, :class => css_class do
            html << (options[:header] || String.new)
          end
        else
          html << (options[:header] || String.new)
        end
      end
    end

    def cell_options
      Hash.new.tap do |opts|
        opts[:style] = "display: none;"    if options[:hidden]
        opts[:class] = options[:css_class] if options[:css_class]
      end
    end
    
    def content_cell(html, item)
      html.td(cell_options) do
        html << contents_for(item)
      end
    end
    
  end
  
end
