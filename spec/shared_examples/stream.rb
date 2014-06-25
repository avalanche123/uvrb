require 'spec_helper'

shared_examples_for 'a stream' do
  describe "#listen" do
    it "raises if no block given" do
      expect { subject.listen(128) }.to raise_error(ArgumentError)
    end

    it "calls UV.listen" do
      backlog = 128
      UV.should_receive(:listen).once.with(pointer, backlog, subject.method(:on_listen))
      subject.listen(backlog) { |e| }
    end
  end

  describe "#accept" do
    let(:client_pointer) { double() }
    let(:client) { double() }

    before(:each) do
      client.stub(:handle) { client_pointer }
    end

    it "makes another stream and calls UV.accept with current and other pointers" do
      loop.should_receive(handle_name).once.and_return(client)
      UV.should_receive(:accept).with(pointer, client_pointer)
      subject.accept.should == client
    end
  end

  describe "#start_read" do
    it "raises if no block given" do
      expect { subject.start_read }.to raise_error(ArgumentError)
    end

    it "calls UV.read_start" do
      UV.should_receive(:read_start).with(pointer, subject.method(:on_allocate), subject.method(:on_read))
      subject.start_read { |e, data| }
    end
  end

  describe "#stop_read" do
    it "calls UV.read_stop" do
      UV.should_receive(:read_stop).with(pointer)
      subject.stop_read
    end
  end

  describe "#write" do
    let(:write_request) { double() }
    let(:buffer) { double() }
    let(:buffer_pointer) { double() }

    it "raises if no block given" do
      expect { subject.write("123") }.to raise_error(ArgumentError)
    end

    it "calls UV.write" do
      data = "some random string"
      size = data.size
      callback = double('write callback')

      UV::Listener.should_receive(:callback).and_return(callback)

      FFI::MemoryPointer.should_receive(:from_string).with(data).and_return(buffer_pointer)
      UV.should_receive(:buf_init).with(buffer_pointer, size).and_return(buffer)
      UV.should_receive(:allocate_request_write).and_return(write_request)
      UV.should_receive(:write).with(write_request, pointer, buffer, 1, callback)

      subject.write(data) { |e| }
    end
  end

  describe "#shutdown" do
    let(:shutdown_request) { double() }

    it "raises if no block given" do
      expect { subject.shutdown }.to raise_error(ArgumentError)
    end

    it "calls UV.shutdown" do
      UV.should_receive(:allocate_request_shutdown).and_return(shutdown_request)
      UV.should_receive(:shutdown).with(shutdown_request, pointer, subject.method(:on_shutdown))

      subject.shutdown { |e| }
    end
  end

  describe "#readable?" do
    it "is true for positive integers" do
      UV.should_receive(:is_readable).with(pointer).and_return(1)
      subject.readable?.should be_true
    end

    it "is false for integers less than 1" do
      UV.should_receive(:is_readable).with(pointer).and_return(-1)
      subject.readable?.should be_false
    end
  end

  describe "#writable?" do
    it "is true for positive integers" do
      UV.should_receive(:is_writable).with(pointer).and_return(1)
      subject.writable?.should be_true
    end

    it "is false for integers less than 1" do
      UV.should_receive(:is_writable).with(pointer).and_return(-1)
      subject.writable?.should be_false
    end
  end
end