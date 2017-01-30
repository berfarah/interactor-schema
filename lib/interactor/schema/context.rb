module Interactor
  module Schema
    class Context
      def self.build(context = {}, schema = [])
        self === context ? context : new(schema).tap do |instance|
          instance.assign(context)
        end
      end

      attr_reader :table
      alias_method :to_h, :table

      def initialize(schema = [])
        @table = {}
        define_schema_methods(schema)
      end

      def [](key)
        @table[key]
      end

      def assign(context)
        @table.merge!(context)
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

      private

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
