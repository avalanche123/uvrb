require 'spec_helper'

describe UV::Loop do
  let(:loop) { double() }

  describe ".default" do
    it "calls uv_loop_default internally" do
      UV.should_receive(:default_loop).once.and_return(loop)
      FFI::AutoPointer.should_receive(:new).once.with(loop, UV.method(:loop_delete))
      UV::Loop.default
    end
  end

  describe ".new" do
    it "calls uv_loop_new" do
      UV.should_receive(:loop_new).once.and_return(loop)
      FFI::AutoPointer.should_receive(:new).once.with(loop, UV.method(:loop_delete))
      UV::Loop.new
    end
  end
end
