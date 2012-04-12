require 'spec_helper'

describe UV::Loop do
  subject { UV::Loop.default }

  it 'returns same loop instance every time' do
    subject.should == UV::Loop.default
  end
end
