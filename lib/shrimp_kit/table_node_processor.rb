module ShrimpKit
  module NodeProcessor

    class TableHolder
      attr_accessor :rows

      def initialize() @rows = [] end
    end # TableHolder

    class RowHolder
      attr_accessor :children

      def initialize() @children = [] end
    end # RowHolder

    class CellHolder
      attr_accessor :text, :styles

      def initialize(text:, styles:)
        @text = text
        @styles = styles
      end
    end # CellHolder

    @table_depth = 0

    class << self

      def table_holder
        @table_holders[@table_depth - 1]
      end

      def row_holder
        table_holder.rows.last
      end

      def process_table_node(node, current_container)
        @table_holders = [] if @table_depth == 0
        @table_holders << TableHolder.new
        @table_depth += 1
        raise "no nesting supported so far" if @table_depth > 1
        process(node.children, nil) if node.children.present?
        e = TableElement.new(
          node: node,
          parent: current_container,
          table_holder: table_holder
        )
        @table_depth -= 1
        @table_holders.delete_at @table_depth
        nil
      end

      def process_td_node(node, current_container)
        # puts node.inspect
        process(node.children, row_holder)
        # puts row_holder.inspect
        nil
      end

      alias_method :process_th_node, :process_td_node

      def process_tr_node(node, current_container)
        table_holder.rows << RowHolder.new
        process(node.children, nil) if node.children.present?
        nil
      end

      def process_tbody_node(node, current_container)
        process(node.children, self) if node.children.present?
        nil
      end

      alias_method :process_thead_node, :process_tbody_node
      alias_method :process_tfoot_node, :process_tbody_node

    end # class << self
  end # NodeProcessor
end # ShrimpKit
