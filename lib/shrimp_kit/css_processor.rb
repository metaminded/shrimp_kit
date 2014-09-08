require 'csspool'
require 'yaml'

module ShrimpKit
  class CssProcessor

    class CssRule
      attr_reader :selector, :declarations, :specificity, :dynamic_pseudo_class
      DYNAMIC_PSEUDO_CLASSES = %w(link visited active hover focus target enabled disabled checked)
      DYNAMIC_PSEUDO_CLASSES_MATCHER = /:(#{DYNAMIC_PSEUDO_CLASSES.join('|')})$/

      def initialize(selector, declarations, specificity)
        @specificity = specificity
        @selector, @dynamic_pseudo_class = selector.split DYNAMIC_PSEUDO_CLASSES_MATCHER
        @selector.sub! /$^/, '*'
        @declarations = {}
        declarations.each do |declaration|
          add_declaration(declaration)
        end
      end

      def to_hash()
        @declarations
      end

      def add_declaration(declaration)
        prop = declaration.property
        expr = declaration.expressions
        return send("add_#{prop}_declaration", expr) if respond_to?("add_#{prop}_declaration")
        raise "multi-value property: #{pop}!" if expr.length > 1
        @declarations[prop] = term_to_ruby(expr.first)
      end

      def add_margin_declaration(expressions)
        case expressions.length
        when 1
          v = term_to_ruby(expressions[0])
          @declarations['margin-top'] = v
          @declarations['margin-right'] = v
          @declarations['margin-bottom'] = v
          @declarations['margin-left'] = v
        when 2
          v1 = term_to_ruby(expressions[0])
          v2 = term_to_ruby(expressions[1])
          @declarations['margin-top'] = v1
          @declarations['margin-right'] = v2
          @declarations['margin-bottom'] = v1
          @declarations['margin-left'] = v2
        when 3
          @declarations['margin-top'] = term_to_ruby(expressions[0])
          @declarations['margin-right'] =
          @declarations['margin-left'] = term_to_ruby(expressions[1])
          @declarations['margin-bottom'] = term_to_ruby(expressions[2])
        when 4
          @declarations['margin-top'] = term_to_ruby(expressions[0])
          @declarations['margin-right'] = term_to_ruby(expressions[1])
          @declarations['margin-bottom'] = term_to_ruby(expressions[2])
          @declarations['margin-left'] = term_to_ruby(expressions[3])
        end
      end

      def add_padding_declaration(expressions)
        case expressions.length
        when 1
          v = term_to_ruby(expressions[0])
          @declarations['padding-top'] = v
          @declarations['padding-right'] = v
          @declarations['padding-bottom'] = v
          @declarations['padding-left'] = v
        when 2
          v1 = term_to_ruby(expressions[0])
          v2 = term_to_ruby(expressions[1])
          @declarations['padding-top'] = v1
          @declarations['padding-right'] = v2
          @declarations['padding-bottom'] = v1
          @declarations['padding-left'] = v2
        when 3
          @declarations['padding-top'] = term_to_ruby(expressions[0])
          @declarations['padding-right'] = term_to_ruby(expressions[1])
          @declarations['padding-bottom'] = term_to_ruby(expressions[2])
          @declarations['padding-left'] = term_to_ruby(expressions[1])
        when 4
          @declarations['padding-top'] = term_to_ruby(expressions[0])
          @declarations['padding-right'] = term_to_ruby(expressions[1])
          @declarations['padding-bottom'] = term_to_ruby(expressions[2])
          @declarations['padding-left'] = term_to_ruby(expressions[3])
        end
      end

      def term_to_ruby(term)
        case term
        when CSSPool::Terms::Number then
          # puts "#{term.value} #{term.type}"
          v = term.value
          v.send(term.type.to_s) if term.type
          v
        when CSSPool::Terms::Ident then term.value
        when CSSPool::Terms::String then term.value
        when CSSPool::Terms::Hash then
          v = term.value[1..-1]
          v = "#{v[0]}#{v[0]}#{v[1]}#{v[1]}#{v[2]}#{v[2]}" if v.length == 3
          v
        when CSSPool::Terms::Rgb then
          '%02x%02x%02x' % [term.red.value, term.green.value, term.blue.value]
        # when CSSPool::Terms::Function then
        # when CSSPool::Terms::URI then
        # when CSSPool::Terms::Resolution then
        # when CSSPool::Terms::Math then
        else raise "Dunno how to handle #{term.class}: "
        end
      end
    end

    attr_reader :nodes

    def initialize(*csss)
      @rules = []
      csss.each.with_index do |css, i|
        CSSPool::CSS(css).rule_sets.each do |rs|
          rs.selectors.each do |sel|
            @rules << CssRule.new(sel.to_s, sel.declarations, "0#{sel.specificity.join}")
          end
        end
      end
    end

    def apply_to(html)
      all_nodes = {}
      @rules.each do |rule|
        nodes = html.css(rule.selector)
        nodes.each do |node|
          (all_nodes[node] ||= []) << rule
        end
      end
      all_nodes.each do |node, rules|
        rr = rules.sort_by(&:specificity).inject({}) do |a,e| a.merge(e.to_hash) end
        # puts "#{node.name} -> #{rr}"
        node['-shrimp-kit-styles'] = rr.to_yaml
      end
    end
  end
end
