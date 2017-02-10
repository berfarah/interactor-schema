module Interactor
  module Schema
    class Context
      def self.build(context = {}, schema = [])
        self === context ? context : new(schema).tap do |instance|
          instance.assign(context)
        end
      end

      def initialize(schema = [])
        @schema = schema
        @table = {}
        define_schema_methods(schema)
      end

      def [](key)
        @table[key]
      end

      def assign(context)
        filtered_context = context.to_h.select { |k, _| _schema.include?(k) }
        @table.merge!(filtered_context)
      end

      def success?
        !failure?
      end

      def failure?
        @failure || false
      end

      def fail!(context = {})
        @table.merge!(context)
        @failure = true
        raise Interactor::Failure, self
      end

      def called!(interactor)
        _called << interactor
      end

      def rollback!
        return false if @rolled_back
        _called.reverse_each(&:rollback)
        @rolled_back = true
      end

      def _called
        @called ||= []
      end

      def _schema
        @schema
      end

      def to_h
        @table
      end

      private

      attr_reader :table

      def define_schema_methods(schema)
        singleton_class.class_exec(schema) do |names|
          names.each do |name|
            define_method(name) do
              @table[name]
            end

            define_method("#{name}=") do |value|
              @table[name] = value
            end
          end
        end
      end
    end
  end
end
