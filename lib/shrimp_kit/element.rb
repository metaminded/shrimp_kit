require 'text/hyphen'

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
      if list.present?
        render_formatted_text(pdf, list, {align: (all_styles['text-align'] || :left).to_sym})
      end
      pdf.move_down @styles['margin-top']
      if @bullet.present?
        c = pdf.y
        pdf.text @bullet
        cc = pdf.y
        if cc < c
          pdf.move_up (c - pdf.y).abs
        else
          pdf.move_up (pdf.bounds.top_left[1] - pdf.cursor)
        end
      end
      pdf.indent @styles['margin-left'] || 0 do
        l = children.inject([]) do |a, e|
          e.render(pdf, list: a, options: @options)
        end
        render_formatted_text(pdf, l, {align: (all_styles['text-align'] || :left).to_sym}) if l.present?
        # pdf.formatted_text(l, {align: (@styles['text-align'] || :left).to_sym}) if l.present?
      end
      pdf.move_down @styles['margin-bottom']
      []
    end

    def render_private_inline(pdf, list:)
      as = all_styles
      # puts "<type> = <#{@type}>"
      # puts "<text> = <#{text}>"
      # puts "list = <#{list}>"
      list << for_formatted_text if text # && list
      children.inject(list) do |a,e|
        e.render(pdf, list: a, options: @options)
      end
    end

    def hyphenator
      @_hyphenator = Text::Hyphen.new(language: @options[:language] || 'de', left: 0, right: 0)
    end

    def render_formatted_text(pdf, list, options)
      if options[:align] == :justify
        list.map! do |elem|
          words = elem[:text].split(' ')
          leading_whitespace = elem[:text].count(' ') - elem[:text].lstrip.count(' ')
          ending_whitespace  = elem[:text].count(' ') - elem[:text].rstrip.count(' ')
          words.map! do |word|
            breaks = hyphenator.hyphenate(word)
            breaks.reverse.each do |b|
              word = word.insert(b, "#{Prawn::Text::SHY}")
            end
            word
          end
          elem[:text] = ' ' * leading_whitespace + words.join(' ') + ' ' * ending_whitespace
          elem
        end
      end
      pdf.formatted_text(list, options)
    end

    def for_formatted_text
      prawn_styles.merge text: text
    end
  end # Element
end # ShrimpKit

require_relative './elements/table_element'
require_relative './elements/image_element'
