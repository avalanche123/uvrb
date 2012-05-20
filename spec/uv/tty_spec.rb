require 'spec_helper'

describe UV::TTY do
  let(:handle_name) { :tty }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::TTY.new(loop, pointer) }

  it_behaves_like 'a handle'
  it_behaves_like 'a stream'

  describe "#enable_raw_mode" do
    it "calls UV.tty_set_mode" do
      UV.should_receive(:tty_set_mode).with(pointer, 1)

      subject.enable_raw_mode
    end
  end

  describe "#disable_raw_mode" do
    it "calls UV.tty_set_mode" do
      UV.should_receive(:tty_set_mode).with(pointer, 0)

      subject.disable_raw_mode
    end
  end

  describe "#reset_mode" do
    it "calls UV.tty_reset_mode" do
      UV.should_receive(:tty_reset_mode)

      subject.reset_mode
    end
  end

  describe "#winsize" do
    let(:width) { 100 }
    let(:height) { 100 }
    let(:width_pointer) { double() }
    let(:height_pointer) { double() }

    it "calls UV.tty_get_winsize" do
      FFI::MemoryPointer.should_receive(:new).once.with(:int).and_return(width_pointer)
      FFI::MemoryPointer.should_receive(:new).once.with(:int).and_return(height_pointer)
      width_pointer.should_receive(:get_int).with(0).and_return(width)
      height_pointer.should_receive(:get_int).with(0).and_return(height)

      UV.should_receive(:tty_get_winsize).with(pointer, width_pointer, height_pointer)

      subject.winsize.should == [width, height]
    end
  end
end