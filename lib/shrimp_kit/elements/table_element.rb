module ShrimpKit
  class TableElement
    attr_accessor :parent, :node, :table_holder

    def initialize(node:, parent:, table_holder:)
      @node = node
      @parent = parent
      @parent.children << self if @parent
      @table_holder = table_holder
    end

    def render_private(pdf, list:)
      cell_styles = {}
      ll = table_holder.rows.map.with_index do |row, i|
        row.children.map.with_index do |cell, j|
          cell_styles[[i,j]] = cell.prawn_styles
          cell.node.text
        end
      end
      pdf.table ll do
        cell_styles.each do |(i,j),s|
          # puts "#{i} #{j} #{s}"
          row(i).column(j).font_style = s[:styles].first
        end
      end
      nil
    end

  end # TableElement
end # ShrimpKit
