module ShrimpKit
  class ImageElement
    attr_accessor :parent, :node, :table_holder

    def initialize(node:, type:, parent:, text: nil, styles: {}, bullet: nil)
      @node = node
      @parent = parent
      @parent.children << self if @parent
    end

    def render_private(pdf, list:)
      pdf.text node['src']
      nil
    end

  end # TableElement
end # ShrimpKit
