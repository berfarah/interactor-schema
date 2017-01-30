module Interactor
  describe Schema do
    include_examples :lint

    describe ".schema" do
      context "with an Interactor" do
        let(:interactor) do
          Class.new do
            include Interactor
            include Interactor::Schema

            schema :foo
          end
        end
        let(:context) { double(:context) }

        it "s schema is passed to its context" do
          expect(Interactor::Schema::Context).to receive(:build).once.with({ foo: "bar" }, [:foo]) { context }

          instance = interactor.new(foo: "bar")

          expect(instance).to be_a(interactor)
          expect(instance.context).to eq(context)
        end
      end

      context "with an Interactor::Organizer" do
        let(:interactor1) do
          Class.new do
            include Interactor

            def call
              context.baz = "yolo"
            end
          end
        end

        let(:interactor2) do
          Class.new.send(:include, Interactor)
        end

        let(:organizer) do
          # Need to cache these for some reason
          klass_1 = interactor1
          klass_2 = interactor2

          Class.new do
            include Interactor::Organizer
            include Interactor::Schema

            schema :foo, :baz
            organize klass_1, klass_2
          end
        end

        it "passes around its context" do
          context = organizer.call(foo: "bar")

          expect(context.foo).to eq("bar")
          expect(context.baz).to eq("yolo")
        end

        context "when assigning an attribute not available in the schema" do
          let(:interactor2) do
            Class.new do
              include Interactor

              def call
                context.undefined = "hi"
              end
            end
          end

          it "raises a NoMethodError" do
            expect {
              organizer.call(foo: "bar")
            }.to raise_error(NoMethodError)
          end
        end
      end
    end
  end
end
