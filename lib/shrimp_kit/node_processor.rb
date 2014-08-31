module ShrimpKit
  module NodeProcessor
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
        if respond_to?("process_#{node.name}_node")
          e = send("process_#{node.name}_node", node, current_container)
        else
          e = Element.new(
            type: node.name,
            parent: current_container
          )
        end
        process(node.children, e) if e && node.children.present?
      end

      def process_br_node(node, current_container)
        e = Element.new(
          type: :_text_,
          text: "\n",
          parent: current_container
        )
        false
      end

      def process_text_node(node, current_container)
        return if node.text.blank?
        e = Element.new(
          type: :_text_,
          text: node.text.try(:gsub, /\s+/, ' '),
          parent: current_container
        )
      end
    end # class << self
  end # NodeProcessor
end # ShrimpKit
