module Rulezilla
  module DSL
    def self.included(base)
      base.extend ClassMethods
      create_klass(base)
    end

    def self.get_super(klass)
      Object.const_get (['Object'] + klass.name.split('::'))[0..-2].join('::')
    end

    def self.demodulize_klass_name(klass_name)
      klass_name.split('::').last
    end

    def self.create_klass(parent_klass)
      klass_name = parent_klass.name

      klass = get_super(parent_klass).const_set("#{demodulize_klass_name(klass_name)}Record", Class.new)

      klass.class_eval do
        include Rulezilla::BasicSupport
        include Object.const_get("#{klass_name}Support") rescue NameError

        attr_reader :record

        define_method(:initialize) do |record|
          record = OpenStruct.new(record) if record.is_a?(Hash)
          instance_variable_set('@record', record)
        end

        define_method(:method_missing) do |meth, *args, &block|
          record.send(meth, *args, &block)
        end
      end

      private_class_method :get_super
      private_class_method :demodulize_klass_name
    end

    module ClassMethods
      def mandatory_attributes
        @mandatory_attributes ||= []
      end

      def apply(record={})
        result_node = trace(record).last

        result_node.nil? ? nil : result_node.result(record_klass_instance(record))
      end

      def all(record={})
        tree.find_all(record)
      end

      def results(record=nil)
        tree.all_results(record_klass_instance(record)).uniq
      end

      def trace(record=nil)
        validate_missing_attributes(record)

        tree.trace(record_klass_instance(record))
      end

      private

      def tree
        @tree ||= Tree.new(Node.new())
      end

      def record_klass_instance(record)
        Object.const_get("#{self.name}Record").new(record)
      end

      def missing_attributes(record)
        record = OpenStruct.new(record) if record.is_a?(Hash)
        mandatory_attributes.map(&:to_sym) - record.methods
      end

      def validate_missing_attributes(record)
        raise "Missing #{missing_attributes(record).join(', ')} attributes from: #{record}" unless missing_attributes(record).empty?
      end

      # DSL methods
      def validate_attributes_presence(*fields)
        @mandatory_attributes = mandatory_attributes | fields
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

      # End of DSL methods
    end
  end
end
