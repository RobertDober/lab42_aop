require 'spec_helper'

describe AOP do
  
  context 'nested, block based, around aspect' do 
    before do
      class_under_test.new_method :main do |a| @a += a end
      class_under_test.around :main do |concern, a|
        @a += 1
        concern.( a )
        @a *= 2
      end
      class_under_test.around :main do |concern, a|
        @a = 0
        concern.( a )
        @a += 1
      end
    end
    it 'returns the consern\'s result' do
      expect( subject.main 41 ).to eq 42
    end
    it 'runs the around code (before part in reverse order, after part in definition order)' do
      subject.main 41
      expect( subject.a ).to eq 85
    end

  end # context 'nested, block based, around aspect'

end # describe AOP
