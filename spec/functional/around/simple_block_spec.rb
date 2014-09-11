require 'spec_helper'

describe AOP, :wip do

  context 'simple, block based, around aspect' do 
    before do
      class_under_test.new_method :main do |a| @a += a end
      class_under_test.around :main do |concern, a|
        @a = 0
        concern.( a )
        @a += 1
      end
    end
    it 'returns the consern\'s result' do
      expect( subject.main 41 ).to eq 41
    end
    it 'runs the around code' do
      subject.main 41
      expect( subject.a ).to eq 42
    end
  end # context 'simple, block based, around aspect'
  
end # describe AOP
