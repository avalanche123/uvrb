require 'spec_helper'

describe UV::Async do
  let(:handle_name) { :async }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::Async.new(loop, pointer) {} }

  it_behaves_like 'a handle'

  describe "#initialize" do
    it "requires a block" do
      expect { UV::Async.new(loop, pointer) }.to raise_error(ArgumentError)
    end
  end

  describe "#send" do
    it "calls UV.async_send" do
      UV.should_receive(:async_send).with(pointer)

      subject.send
    end
  end
end