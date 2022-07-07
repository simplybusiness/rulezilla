# frozen_string_literal: true

module Rulezilla
  class Node
    attr_accessor :children,
                  :condition,
                  :parent

    attr_reader   :default, :name
    attr_writer   :result

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

      !!record.instance_eval(&condition)
    end

    def result(record)
      @result.is_a?(Proc) ? record.instance_eval(&@result) : @result
    end

    def name=(value)
      @name = value.to_s
    end

    def add_child(node)
      node.parent = self
      children << node
    end
  end
end
