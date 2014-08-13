module Rulezilla
  class Tree
    attr_reader :current_node, :root_node

    def initialize(node)
      @root_node      = node
      @root_node.name = :root
      @current_node   = node
    end

    def go_up
      @current_node = is_root? ? @root_node : @current_node.parent
    end

    def trace(record, node=@root_node)
      if node.applies?(record)
        if node.has_children?
          node.children.each do |child_node|
            array = trace(record, child_node)
            return [node] + array unless array.empty?
          end
        end
        return node.has_result? ? [node] : []
      end
      return []
    end

    def all_results(record, node=@root_node, results=[])
      if node.has_result?
        results << node.result(record) rescue NoMethodError
      end

      node.children.each do |child_node|
        results += all_results(record, child_node, results)
      end

      return results
    end

    def create_and_move_to_child(name=nil)
      node = Node.new
      node.name = name
      @current_node.add_child(node)
      @current_node = node
      node
    end

    private
    def is_root?
      @current_node == @root_node
    end
  end
end
