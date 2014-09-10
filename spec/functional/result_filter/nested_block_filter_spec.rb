require 'spec_helper'

describe AOP do
  context 'nested block result filters' do 
    before do
      class_under_test.new_method :double do |n| n*2 end
      class_under_test.result_filter :double do |r|
        @a = r
        r.succ
      end
      class_under_test.result_filter :double do |r|
        @b = r
        r * 2
      end
    end
    
    it 'has no side effects' do
      subject.double 0
      expect( subject.a ).to be_nil
      expect( subject.b ).to be_nil
    end

    it 'transforms the result correctly' do
      expect( subject.double 10 ).to eq 42
    end
    
  end # context 'nested block result filters'
  
end # describe AOP
