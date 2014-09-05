module ShrimpKit
  module ListNodeProcessor

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
      Element.create(
        node: node,
        type: node.name,
        parent: current_container,
        bullet: bullet
      )
    end
  end # ListNodeProcessor
end # ShrimpKit
