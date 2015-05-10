require 'spec_helper'

describe Lita::Handler, lita: true do
  let(:robot) { instance_double("Lita::Robot", name: "Lita") }
  let(:user) { instance_double("Lita::User", name: "Test User") }

  let(:handler_class) do
    Class.new(described_class) do
      config :foo
      config :bar, required: false
      config :baz, default: "default value"

      def self.name
        "FooHandler"
      end
    end
  end

  subject { handler_class.new(robot) }

  it "auto-registers Lita::Handler sub-classes" do
    class TestHandler < Lita::Handler
    end
    Lita::Ext::Core.send(:register_app_handlers)
    expect(Lita.handlers).to include(TestHandler)
  end

  describe '#log' do
    it "returns the Lita logger" do
      expect(subject.log).to eq(Lita.logger)
    end
  end
end
