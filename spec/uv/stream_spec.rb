require 'spec_helper'

shared_examples_for 'a stream' do
  it "can listen and accept" do
    @received = []

    start_server do |server|
      server.listen(128) do
        client = server.accept
        client.write("accepted") do
          client.close
          server.close
        end
      end
    end

    start_client do |client|
      client.start_read do |data, err|
        @received << data
        client.close
      end
    end

    UV::Loop.default.run

    @received.should == ["accepted"]
  end
end
