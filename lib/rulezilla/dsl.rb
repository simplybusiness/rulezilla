module Rulezilla
  module DSL
    def self.included(base)
      base.extend ClassMethods
      create_klass(base)
    end

    def self.create_klass(parent_klass)
      klass_name = parent_klass.name
      klass = parent_klass.parent.const_set("#{klass_name.demodulize}Record", Class.new)

      klass.class_eval do
        include Rules::BasicSupport
        include "#{klass_name}Support".constantize rescue NameError

        attr_reader :record

        define_method(:initialize) do |record|
          record = OpenStruct.new(record) if record.is_a?(Hash)
          instance_variable_set('@record', record)
        end

        define_method(:method_missing) do |meth, *args, &block|
          record.send(meth, *args, &block)
        end
      end
    end

    module ClassMethods
      def mandatory_attributes
        @mandatory_attributes ||= []
      end

      def apply(record={})
        validate_missing_attributes(record)

        tree.find(record_klass_instance(record))
      end

      def results(record=nil)
        tree.all_results(record_klass_instance(record)).uniq
      end

      private

      def tree
        @tree ||= Tree.new(Node.new())
      end

      def validate_attributes_presence(*fields)
        @mandatory_attributes = mandatory_attributes | fields
      end

      def missing_attributes(record)
        record = record.attributes unless record.is_a? Hash
        mandatory_attributes.reject{ |field| record.keys.map(&:to_sym).include? field }
      end

      def validate_missing_attributes(record)
        raise "Missing #{missing_attributes(record).join(', ')} attributes from: #{record}" unless missing_attributes(record).empty?
      end

      def define(name=nil, &block)
        tree.create_and_move_to_child(name)

        instance_eval(&block)
        tree.go_up
      end
      alias_method :group, :define

      def condition(&block)
        tree.current_node.condition = block
      end

      def result(value=nil, &block)
        tree.current_node.result = value.nil? ? block : value
      end
      alias_method :default, :result

      def record_klass_instance(record)
        "#{self.name}Record".constantize.new(record)
      end
    end
  end
end
