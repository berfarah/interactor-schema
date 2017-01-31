module Interactor
  module ClassMethods
    # Depends on Interactor::Hook
    def require_in_context(*attributes)
      before :require_in_context!
      @required_in_context = attributes
    end

    def delegate_to_context(*attributes)
      attributes.each do |attribute|
        define_method(attribute) { context[attribute] }
      end
    end

    attr_reader :required_in_context
  end

  private

  def required_in_context
    self.class.required_in_context
  end

  def require_in_context!
    missing_attributes = required_in_context.select do |attribute|
      context[attribute].nil?
    end

    return if missing_attributes.empty?
    raise ArgumentError, <<-MESSAGE.strip
      Missing the following attributes in context: #{missing_attributes.join(', ')}
    MESSAGE
  end
end
