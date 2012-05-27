require 'spec_helper'

describe UV::Async do
  let(:handle_name) { :async }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::Async.new(loop, pointer) { |e| } }

  it_behaves_like 'a handle'

  describe "#call" do
    it "calls UV.async_send" do
      UV.should_receive(:async_send).with(pointer)

      subject.call
    end
  end
end