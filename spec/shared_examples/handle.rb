require 'spec_helper'

shared_examples_for 'a handle' do
  def handle_name
    described_class.name.split('::').last.downcase
  end

  def create_handle
    loop_ptr = double()
    handle_ptr = double()

    loop.stub(:to_ptr) { loop_ptr }

    UV.should_receive(:handle_size).with("uv_#{handle_name}".to_sym).and_return(100)
    UV.should_receive(:malloc).with(100).and_return(handle_ptr)
    UV.should_receive("#{handle_name}_init") { |l, h| 0 }

    described_class.new(loop)
  end

  let(:loop) { double() }

  describe "#initialize" do
    before(:each) do
      loop_ptr = double()
      handle_ptr = double()

      loop.stub(:to_ptr) { loop_ptr }

      UV.should_receive(:handle_size).with("uv_#{handle_name}".to_sym).and_return(100)
      UV.should_receive(:malloc).with(100).and_return(handle_ptr)
      UV.should_receive("#{handle_name}_init") do |l, h|
        h.should == handle_ptr
        l.should == loop_ptr
        rc
      end
    end

    context "failure to initialize handle" do
      let(:rc) { -1 }

      it "raises UV::Error" do
        err = UV::Error::OK.new("error")
        loop.stub(:last_error) { err }
        expect { described_class.new(loop) }.to raise_error(err)
      end
    end

    context "successful initialize handle" do
      let(:rc) { 0 }

      it "accepts a loop and calls correct uv_handle_init" do
        described_class.new(loop)
      end
    end
  end

  describe "#close" do
    context "block given" do
      it "calls uv_close" do
        UV.should_receive(:close).once do |handle, on_close|
          ptr = double()
          UV.should_receive(:free).once.with(ptr)
          on_close.call(ptr).should == true
          nil
        end

        handle = create_handle
        handle.close { true }
      end
    end
  end

  describe "#active?" do
    context "uv_is_active returns more than 0" do
      it "evaluates to true" do
        handle = create_handle
        UV.should_receive(:is_active).once.with(handle.to_ptr).and_return(1)
        handle.active?.should be(true)
      end
    end

    context "uv_is_active returns 0" do
      it "evaluates to false" do
        handle = create_handle
        UV.should_receive(:is_active).once.with(handle.to_ptr).and_return(0)
        handle.active?.should be(false)
      end
    end
  end

  describe "#closing?" do
    context "uv_is_closing returns more than 0" do
      it "evaluates to true" do
        handle = create_handle
        UV.should_receive(:is_closing).once.with(handle.to_ptr).and_return(1)
        handle.closing?.should be(true)
      end
    end

    context "uv_is_closing returns 0" do
      it "evaluates to false" do
        handle = create_handle
        UV.should_receive(:is_closing).once.with(handle.to_ptr).and_return(0)
        handle.closing?.should be(false)
      end
    end
  end
end