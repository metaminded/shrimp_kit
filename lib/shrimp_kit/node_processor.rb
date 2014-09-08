module ShrimpKit
  class NodeProcessor

    def self.process(body, css_files: [])
      container = Element.new(node: body, type: :body, parent: nil)
      @css = CssProcessor.new(ShrimpKit::DEFAULT_STYLES)
      @css.apply_to(body)
      new().process(body.children, container)
      container
    end

    def initialize()
      @list_mode = nil
      @ol_depth = 0
      @ul_depth = 0
      @uli_count = {}
      @oli_count = {}
      @table_depth = 0
    end

    def process(nodes, container)
      nodes.each do |node|
        case node
        when Nokogiri::XML::Element then process_node(node, container)
        when Nokogiri::XML::Text then process_text_node(node, container)
        when Nokogiri::XML::Comment then "do nothing"
        else raise "HELP! A #{node.class}, kill it!"
        end
      end
    end

    def process_node(node, current_container)
      # puts "#{node.name}"
      e = if respond_to?("process_#{node.name}_node")
        send("process_#{node.name}_node", node, current_container)
      else
        process_default_node(node, current_container)
      end
      process(node.children, e) if e && node.children.present?
    end

    def process_default_node(node, current_container)
      Element.create(
        node: node,
        type: node.name,
        parent: current_container
      )
    end

    def process_br_node(node, current_container)
      Element.create(
        node: node,
        type: :_text_,
        text: "\n",
        parent: current_container
      )
      false
    end

    def process_text_node(node, current_container)
      # puts "_text_: #{node.text}"
      return if node.text.blank?
      Element.create(
        node: node,
        type: :_text_,
        text: node.text.try(:gsub, /\s+/, ' '),
        parent: current_container
      )
    end

    require_relative './node_processors/list_node_processor'

    include ListNodeProcessor
  end # NodeProcessor
end # ShrimpKit

