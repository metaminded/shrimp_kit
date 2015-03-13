module ShrimpKit
  class ImageElement
    attr_accessor :parent, :node, :table_holder

    def initialize(node:, type:, parent:, text: nil, styles: {}, bullet: nil)
      @node = node
      @parent = parent
      @parent.children << self if @parent
    end

    def render(pdf, list:, options: {})
      size = options[:image_size] || 5.cm
      position = options[:image_position] || :center
      if node['src'].present?
        pdf.image File.join((options[:image_path] || '.'), node['src']),
          fit: [size, size],
          position: position
        nil
      else
        []
      end
    end

  end # TableElement
end # ShrimpKit
