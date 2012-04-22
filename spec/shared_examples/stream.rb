require 'spec_helper'

shared_examples_for 'a stream' do
  it_behaves_like 'a handle'

  let(:loop) { double() }
  let(:handle) { double() }

  let(:stream) do
    described_class.new(loop).tap do |s|
      s.stub(:handle) { handle }
    end
  end

  # describe "#listen" do
  #   it "raises if no block given" do
  #     expect { stream.listen(128) }.to raise_error(RuntimeError)
  #   end
  # 
  #   it "calls uv_listen" do
  #     UV.should_receive(:listen)
  #     stream.listen(128)
  #   end
  # end

  describe "#accept" do
    # it "raises when not used inside listen" do
    #   expect { stream.accept }.to raise_error(UV::Error)
    # end
  end
end