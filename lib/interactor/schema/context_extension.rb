require "interactor/context"
require "interactor/schema/context"

module Interactor
  class Context
    # Overriding build method to continue with a Schema Context
    # when one is found
    def self.build(context = {})
      return context if context.is_a?(Interactor::Schema::Context)
      super
    end
  end
end
