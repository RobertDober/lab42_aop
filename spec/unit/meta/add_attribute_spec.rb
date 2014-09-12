require 'spec_helper'

describe AOP::Meta do
  context 'add_attribute' do 
    subject do
      Object.new
    end
    before do
      described_class.add_attribute subject, :alpha
    end

    it 'can be set' do
      subject.alpha = 42
    end
    it 'can be read' do
      subject.alpha = "42"
      expect( subject.alpha ).to eq "42"
    end
  end # context 'add_attribute'

end # describe AOP::Meta
