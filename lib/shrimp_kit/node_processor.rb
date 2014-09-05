module ShrimpKit
  module NodeProcessor
    @list_mode = nil
    @ol_depth = 0
    @ul_depth = 0
    @uli_count = {}
    @oli_count = {}

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
        om = @list_mode
        @list_mode = :ul
        @ul_depth += 1
        @uli_count[@ul_depth] = 0
        e = process_default_node(node, current_container)
        process(node.children, e) if node.children.present?
        @ul_depth -= 1
        @list_mode = om
        nil
      end

      def process_ol_node(node, current_container)
        om = @list_mode
        @list_mode = :ol
        @ol_depth += 1
        @oli_count[@ol_depth] = 0
        e = process_default_node(node, current_container)
        process(node.children, e) if node.children.present?
        @ol_depth -= 1
        @list_mode = om
        nil
      end

      def process_li_node(node, current_container)
        if @list_mode == :ul
          @uli_count[@ul_depth] += 1
          bullet = ShrimpKit::BULLETS[@ul_depth - 1]
        elsif @list_mode == :ol
          @oli_count[@ol_depth] += 1
          bullet = @oli_count.values[0..@ol_depth-1].join('.')
          bullet = "#{bullet}." if @ol_depth == 1
        else
          raise "strange li mode »#{@list_mode}«"
        end
        Element.new(
          node: node,
          type: node.name,
          parent: current_container,
          bullet: bullet
        )
      end

    end # class << self
  end # NodeProcessor
end # ShrimpKit
