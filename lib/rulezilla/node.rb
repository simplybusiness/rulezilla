module Rulezilla
  class Node
    attr_accessor :parent, :children
    attr_reader   :condition, :result, :default, :name

    def initialize
      @children = []
    end

    def has_children?
      children.any?
    end

    def condition=(block)
      @condition = block
    end

    def name=(value)
      @name = value
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
