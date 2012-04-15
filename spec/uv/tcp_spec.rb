require 'spec_helper'

describe UV::TCP do
  def start_server
    server = UV::Loop.default.tcp
    server.bind("0.0.0.0", 10000)
    yield server if block_given?
  end

  def start_client
    client = UV::Loop.default.tcp
    client.connect("127.0.0.1", 10000) do |err|
      yield client if block_given?
    end
  end

  it_behaves_like 'a stream'
end
