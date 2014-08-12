module Rulezilla
  class NodeEvaluator
    attr_reader :node, :record

    def initialize(record, node)
      @node    = node
      @record  = record
    end

    def applies?
      return true if node.condition.nil?
      record.instance_eval(&node.condition)
    end

    def result
      result = node.result
      result.is_a?(Proc) ? record.instance_eval(&result) : result
    end

    def has_result?
      !node.result.nil?
    end
  end
end
