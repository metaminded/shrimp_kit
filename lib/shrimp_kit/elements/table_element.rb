module ShrimpKit
  class TableElement < Element
    attr_accessor :parent, :node, :table_holder

    def initialize(node:, type:, parent:, text: nil, bullet: nil)
      super
    end

    def render(pdf, list:, options: {})
      cell_styles = {}
      ll = children.map.with_index do |row, i|
        row.children.map.with_index do |cell, j|
          styles = cell.children.inject({}) do |a,e| a.merge e.prawn_styles end
          cell_styles[[i,j]] = styles
          # puts "#{cell.node.text}:#{cell.type} => #{styles}"
          cell.node.text
        end
      end
      pdf.table ll do
        cell_styles.each do |(i,j),s|
          # puts "#{i} #{j} #{s}"
          # puts s.inspect
          row(i).column(j).font_style = s[:styles].first
        end
      end
      nil
    end

  end # TableElement
end # ShrimpKit
