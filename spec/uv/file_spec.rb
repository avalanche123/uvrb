require 'spec_helper'

describe UV::File do
  let(:loop) { double() }
  let(:loop_ptr) { double() }
  let(:io) { double() }
  let(:fileno) { rand(6555) }
  let(:pointer) { double() }
  let(:subject) do
    loop.stub(:to_ptr) { loop_ptr }

    UV::File.new(loop, fileno)
  end

  describe "#close" do
    it "calls uv_fs_close" do
      UV.should_receive(:create_request).once.with(:uv_fs).and_return(pointer)
      UV.should_receive(:fs_close).once do |loop_pointer, uv_fs_t, fno, callback|
        loop_pointer.should == loop_ptr
        uv_fs_t.should == pointer
        fno.should == fileno
        UV.should_receive(:fs_req_result).once.with(uv_fs_t).and_return(0)
        UV.should_receive(:fs_req_cleanup).once.with(uv_fs_t)
        UV.should_receive(:free).once.with(uv_fs_t)
        callback.call(uv_fs_t)
      end
      @called = false
      subject.close { @called = true }
      @called.should be(true)
    end
  end
end