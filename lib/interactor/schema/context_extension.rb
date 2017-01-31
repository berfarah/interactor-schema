module Interactor
  class Context
    # Overriding build method to continue with a Schema Context
    # when one is found
    def self.build(context = {})
      return context if context.is_a?(Interactor::Schema::Context)
      self === context ? context : new(context)
    end
  end
end
