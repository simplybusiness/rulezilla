module Rulezilla
  class Node
    attr_accessor :parent, :children
    attr_reader   :condition, :default, :name

    def initialize
      @children = []
    end

    def has_children?
      children.any?
    end

    def has_result?
      !@result.nil?
    end

    def applies?(record)
      return true if condition.nil?
      record.instance_eval(&condition)
    end

    def result(record)
      @result.is_a?(Proc) ? record.instance_eval(&@result) : @result
    end

    def condition=(block)
      @condition = block
    end

    def name=(value)
      @name = value.try(:to_sym)
    end

    def result=(block)
      @result = block
    end

    def add_child(node)
      node.parent = self
      children << node
    end
  end
end
