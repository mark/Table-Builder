module TableBuilderHelper
  
  class TableBuilder
    
    attr_reader :columns
    
    def initialize(view)
      @columns = Array.new
      @view = view
    end
    
    def add_column(options, block)
      columns << TableBuilderHelper::TableColumn.new(options.merge(:unordered => @columns.length), block, @view)
    end

    ###################
    #                 #
    # Builder Methods #
    #                 #
    ###################
    
    def header_row(html, page_requester)
      html.tr do
        columns.each do |column|
          column.header_cell(html, page_requester)
        end
      end
    end

    def content_row(html, item)
      html.tr do
        columns.each { |column| column.content_cell(html, item) }
      end
    end

    def generate(contents, page_requester)
      columns.sort!

      html = Builder::XmlMarkup.new(:indent => 4, :target => Array.new)

      html.table do
        header_row(html, page_requester)

        contents.each { |item| content_row(html, item) }
      end

      html.target!.join
    end
    
  end

end
