require 'table_column'
require 'table_builder'

module TableBuilderHelper

  def column(options = {}, &block)
    @table ||= TableBuilderHelper::TableBuilder.new(self)
    
    @table.add_column(options, block)
  end
  
  def table(contents = [])
    the_table = @table
    @table = nil
    the_table.generate(contents, @requester)
  end

end
