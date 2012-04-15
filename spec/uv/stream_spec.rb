require 'spec_helper'

shared_examples_for 'a stream' do
  let(:server) { described_class.new(UV::Loop.default) }
  let(:client) { described_class.new(UV::Loop.default) }

  it "can listen and accept" do
    @received = []

    server.bind("0.0.0.0", 10000)

    server.listen(128) do
      c = server.accept
      c.write("accepted") do
        c.close
      end
    end

    # client.connect("127.0.0.1", 10000) do
    #   client.start_read do |data, err|
    #     @received << data
    #     client.close
    #   end
    # end

    UV::Loop.default.run

    @received.should == ["accepted"]
  end
end
