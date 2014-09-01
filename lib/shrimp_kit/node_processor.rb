module ShrimpKit
  module NodeProcessor
    @ul_depth = 0
    @li_count = {}

    class << self

      def process(nodes, current_container)
        nodes.each do |node|
          case node
          when Nokogiri::XML::Element then process_node(node, current_container)
          when Nokogiri::XML::Text then process_text_node(node, current_container)
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
        Element.new(
          node: node,
          type: node.name,
          parent: current_container
        )
      end

      def process_br_node(node, current_container)
        Element.new(
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
        Element.new(
          node: node,
          type: :_text_,
          text: node.text.try(:gsub, /\s+/, ' '),
          parent: current_container
        )
      end

      def process_ul_node(node, current_container)
        @ul_depth += 1
        @li_count[@ul_depth] = 0
        e = process_default_node(node, current_container)
        process(node.children, e) if node.children.present?
        @ul_depth -= 1
        nil
      end

      def process_li_node(node, current_container)
        @li_count[@ul_depth] += 1
        Element.new(
          node: node,
          type: node.name,
          parent: current_container,
          bullet: ShrimpKit::BULLETS[@ul_depth - 1]
        )
      end

    end # class << self
  end # NodeProcessor
end # ShrimpKit
