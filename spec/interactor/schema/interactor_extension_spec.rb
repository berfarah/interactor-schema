describe Interactor do
  describe ".require_in_context" do
    let(:interactor) do
      Class.new do
        include Interactor
        require_in_context :foo
      end
    end

    it "fails if the argument isn't passed in" do
      expect { interactor.call }.to raise_error(ArgumentError)
    end

    it "fails if the argument is is nil" do
      expect { interactor.call(foo: nil) }.to raise_error(ArgumentError)
    end

    it "succeeds if the argument is passed in" do
      expect { interactor.call(foo: "bar") }.not_to raise_error
    end
  end

  describe ".delegate_to_context" do
    let(:interactor) do
      Class.new do
        include Interactor
        delegate_to_context :foo

        def call
          foo
        end
      end
    end
    let(:context) { double("Context") }

    it "delegates to the context" do
      expect_any_instance_of(Interactor::Context).to receive(:[]).with(:foo).once
      interactor.call
    end
  end
end
