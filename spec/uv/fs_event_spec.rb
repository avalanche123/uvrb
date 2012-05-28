require 'spec_helper'

describe UV::FSEvent do
  let(:handle_name) { :fs_event }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::FSEvent.new(loop, pointer) { |e, filename, type| } }

  it_behaves_like 'a handle'
end