module Interactor::Schema
  describe Context do
    describe ".build" do
      it "doesn't respond to methods when no schema is given" do
        context = Context.build(foo: "bar")

        expect(context).to be_a(Context)
        expect { context.foo }.to raise_error(NoMethodError)
      end

      it "responds to methods when a schema is given" do
        context = Context.build({ foo: "bar" }, [:foo])

        expect(context).to be_a(Context)
        expect(context.foo).to eq("bar")
      end

      it "only responds to methods defined in the schema" do
        context = Context.build({ foo: "bar" }, [:baz])

        expect(context).to be_a(Context)
        expect { context.foo }.to raise_error(NoMethodError)
      end
    end

    describe "#_schema" do
      let(:context) { Context.build({}, schema) }
      let(:schema) { [:foo] }

      it "is empty by default" do
        context = Context.build
        expect(context._schema).to eq([])
      end

      it "holds onto the schema" do
        expect(context._schema).to eq(schema)
      end
    end

    describe "#to_h" do
      let(:context) { Context.build({ foo: "one", bar: "two" }, [:foo]) }
      it "only records allowed values" do
        expect(context.to_h).to eq(foo: "one")
      end
    end

    # NOTE:
    # The tests below are copied from the original Interactor::Context
    # The only thing modified was to add the context argument where needed.
    #
    # You can find them here:
    # https://github.com/collectiveidea/interactor/blob/master/spec/interactor/context_spec.rb
    describe ".build" do
      it "builds an empty context if no hash is given" do
        context = Context.build

        expect(context).to be_a(Context)
        expect(context.send(:table)).to eq({})
      end

      it "doesn't affect the original hash" do
        hash = { foo: "bar" }
        context = Context.build(hash, [:foo])

        expect(context).to be_a(Context)
        expect {
          context.foo = "baz"
        }.not_to change {
          hash[:foo]
        }
      end

      it "preserves an already built context" do
        context1 = Context.build({ foo: "bar" }, [:foo])
        context2 = Context.build(context1)

        expect(context2).to be_a(Context)
        expect {
          context2.foo = "baz"
        }.to change {
          context1.foo
        }.from("bar").to("baz")
      end
    end

    describe "#success?" do
      let(:context) { Context.build }

      it "is true by default" do
        expect(context.success?).to eq(true)
      end
    end

    describe "#failure?" do
      let(:context) { Context.build }

      it "is false by default" do
        expect(context.failure?).to eq(false)
      end
    end

    describe "#fail!" do
      let(:context) { Context.build({ foo: "bar" }, [:foo]) }

      it "sets success to false" do
        expect {
          context.fail! rescue nil
        }.to change {
          context.success?
        }.from(true).to(false)
      end

      it "sets failure to true" do
        expect {
          context.fail! rescue nil
        }.to change {
          context.failure?
        }.from(false).to(true)
      end

      it "preserves failure" do
        context.fail! rescue nil

        expect {
          context.fail! rescue nil
        }.not_to change {
          context.failure?
        }
      end

      it "preserves the context" do
        expect {
          context.fail! rescue nil
        }.not_to change {
          context.foo
        }
      end

      it "updates the context" do
        expect {
          context.fail!(foo: "baz") rescue nil
        }.to change {
          context.foo
        }.from("bar").to("baz")
      end

      it "raises failure" do
        expect {
          context.fail!
        }.to raise_error(Interactor::Failure)
      end

      it "makes the context available from the failure" do
        begin
          context.fail!
        rescue Interactor::Failure => error
          expect(error.context).to eq(context)
        end
      end
    end

    describe "#called!" do
      let(:context) { Context.build }
      let(:instance1) { double(:instance1) }
      let(:instance2) { double(:instance2) }

      it "appends to the internal list of called instances" do
        expect {
          context.called!(instance1)
          context.called!(instance2)
        }.to change {
          context._called
        }.from([]).to([instance1, instance2])
      end
    end

    describe "#rollback!" do
      let(:context) { Context.build }
      let(:instance1) { double(:instance1) }
      let(:instance2) { double(:instance2) }

      before do
        allow(context).to receive(:_called) { [instance1, instance2] }
      end

      it "rolls back each instance in reverse order" do
        expect(instance2).to receive(:rollback).once.with(no_args).ordered
        expect(instance1).to receive(:rollback).once.with(no_args).ordered

        context.rollback!
      end

      it "ignores subsequent attempts" do
        expect(instance2).to receive(:rollback).once
        expect(instance1).to receive(:rollback).once

        context.rollback!
        context.rollback!
      end
    end

    describe "#_called" do
      let(:context) { Context.build }

      it "is empty by default" do
        expect(context._called).to eq([])
      end
    end
  end
end
