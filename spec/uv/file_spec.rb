require 'spec_helper'

describe UV::File do
  let(:loop) { double() }
  let(:loop_pointer) { double() }
  let(:fd) { rand(6555) }
  subject { UV::File.new(loop, fd) }

  before(:each) do
    loop.stub(:to_ptr) { loop_pointer }
  end

  describe "#close" do
    let(:close_request) { double() }

    it "requires a block" do
      expect { subject.close }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_close" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(close_request)
      UV.should_receive(:fs_close).with(loop_pointer, close_request, fd, subject.method(:on_close))

      subject.close { |e| }
    end
  end

  describe "#read" do
    let(:read_request) { double() }
    let(:length) { 1024 }
    let(:read_buffer) { double() }
    let(:offset) { 0 }

    it "requires a block" do
      expect { subject.read(length, offset) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_read" do
      FFI::MemoryPointer.should_receive(:new).with(length).and_return(read_buffer)
      UV.should_receive(:create_request).with(:uv_fs).and_return(read_request)
      UV.should_receive(:fs_read).with(loop_pointer, read_request, fd, read_buffer, length, offset, subject.method(:on_read))

      subject.read(length, offset) { |e, data| }
    end
  end

  describe "#write" do
    let(:offset) { 0 }
    let(:data) { "some payload" }
    let(:write_buffer_length) { data.size }
    let(:write_buffer) { double() }
    let(:write_request) { double() }

    it "requires a block" do
      expect { subject.write(data, offset) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_write" do
      FFI::MemoryPointer.should_receive(:from_string).with(data).and_return(write_buffer)
      UV.should_receive(:create_request).with(:uv_fs).and_return(write_request)
      UV.should_receive(:fs_write).with(loop_pointer, write_request, fd, write_buffer, write_buffer_length, offset, subject.method(:on_write))

      subject.write(data, offset) { |e| }
    end
  end

  describe "#stat" do
  end

  describe "#sync" do
  end

  describe "#datasync" do
  end

  describe "#truncate" do
  end

  describe "#utime" do
  end

  describe "#chmod" do
  end

  describe "#chown" do
  end
end