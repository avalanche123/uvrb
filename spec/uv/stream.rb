require 'spec_helper'

shared_examples_for 'a stream' do
  let(:stream) { described_class.new(UV::Loop.default) }

  it "can listen and accept" do
    stream.listen(128) do
      client = stream.accept
      client.write("accepted") do
        client.close
      end
    end

    UV::Loop.default.run
  end
end
