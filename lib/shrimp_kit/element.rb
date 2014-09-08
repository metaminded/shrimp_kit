module ShrimpKit
  class Element

    attr_accessor :parent, :children, :text, :type, :node, :styles

    def self.create(args)
      case args[:type].to_s
      when 'img' then ImageElement.new(args)
      when 'table' then TableElement.new(args)
      else Element.new(args)
      end
    end

    def initialize(node:, type:, parent:, text: nil, bullet: nil)
      @type = type.to_s
      @node = node
      raise "Unsupported html tag »#{@type}«" unless ALLOWED_TAGS.member? @type
      @text = text
      @parent = parent
      @parent.children << self if @parent
      @children = []
      @bullet = bullet
      @styles = YAML.parse(node['-shrimp-kit-styles'].presence || "--- {}\n").to_ruby
    end

    def inspect
      "<SKElement #{@type}: #{@text} #{@styles}>"
    end
    alias_method :to_s, :inspect

    def empty?() children.present? end

    def block_element?()
      @_block_element = (@styles['display'] == "block")
    end

   def all_styles()
     @_all_styles ||= (parent.try(:all_styles) || {}).merge(styles)
   end

    def prawn_styles
      as = all_styles
      {
        styles: [as['font-style'].try(:to_sym), as['font-weight'].try(:to_sym)].reject{|s| s == :normal}.compact,
        color: as['color'],
        size: as['font-size']
      }
    end

    def render(pdf, list: [], options: {})
      @options = options
      l = render_private(pdf, list: list)
    end

    def render_private(pdf, list:)
      if block_element?
        render_private_block pdf, list: list
      else
        render_private_inline pdf, list: list
      end
    end

    def render_private_block(pdf, list:)
      as = all_styles
      # puts ">> #{list.count}"
      pdf.formatted_text(list) if list.present?
      pdf.move_down @styles['margin-top']
      if @bullet.present?
        c = pdf.cursor
        pdf.text @bullet
        cc = pdf.cursor
        if cc < c
          pdf.move_up (c - pdf.cursor).abs
        else
          pdf.move_up (pdf.bounds.top_left[1] - pdf.cursor)
        end
      end
      pdf.indent @styles['margin-left'] || 0 do
        l = children.inject([]) do |a, e|
          e.render(pdf, list: a, options: @options)
        end
        pdf.formatted_text l if l.present?
      end
      pdf.move_down @styles['margin-bottom']
      []
    end

    def render_private_inline(pdf, list:)
      as = all_styles
      # puts "#{type} #{for_formatted_text}" if text
      list << for_formatted_text if text
      children.inject(list) do |a,e|
        e.render(pdf, list: a, options: @options)
      end
    end

    def for_formatted_text
      prawn_styles.merge text: text
    end
  end # Element
end # ShrimpKit

require_relative './elements/table_element'
require_relative './elements/image_element'
