require "interactor"
require "interactor/schema/context"
require "interactor/schema/context_extension"
require "interactor/schema/interactor_extension"
require "interactor/schema/version"

module Interactor
  module Schema
    # Internal: Install Interactor::Schema's behavior in the given class.
    def self.included(base)
      base.class_eval do
        # Don't override methods when an Interactor has already been included
        # For example, when Organizer has already been included
        include Interactor unless base.ancestors.include? Interactor

        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      def schema(*method_names)
        @schema = method_names.flatten
      end

      def _schema
        @schema ||= []
      end
    end

    module InstanceMethods
      def initialize(context = {})
        @context = Interactor::Schema::Context.build(context, self.class._schema)
      end
    end
  end
end
