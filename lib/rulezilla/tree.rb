module Rulezilla
  class Tree
    attr_reader :current_node, :root_node

    def initialize(node)
      @root_node    = node
      @current_node = node
    end

    def go_up
      @current_node = is_root? ? @root_node : @current_node.parent
    end

    def find(record, node=@root_node)
      node.children.each do |child_node|
        evaluator = NodeEvaluator.new(record, child_node)
        if evaluator.applies?
          if child_node.has_children?
            value = find(record, child_node)
            return value if value
          else
            next unless evaluator.has_result?
            return evaluator.result
          end
        end
      end

      evaluator = NodeEvaluator.new(record, node)
      return evaluator.result if evaluator.has_result?
    end

    def all_results(record, node=@root_node, results=[])
      node.children.each do |child_node|
        evaluator = NodeEvaluator.new(record, child_node)
        if child_node.has_children?
          results += all_results(record, child_node, results)
          if evaluator.has_result?
            results << evaluator.result rescue NoMethodError
          end
        else
          results << evaluator.result rescue NoMethodError
        end
      end

      evaluator = NodeEvaluator.new(record, node)
      if evaluator.has_result?
        results << evaluator.result rescue NoMethodError
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
