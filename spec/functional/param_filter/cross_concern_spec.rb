require 'spec_helper'

describe AOP do

  before do
    class_under_test.null_methods :a1, :a2, :b1
  end

  context 'cross concern (using param filter block)' do
    before do
      class_under_test.param_filter %r{\Aa}, &:succ
    end

    context 'defines the aspect for all methods starting with a' do 
      it{ expect( subject.a1 1 ).to eq [2] }
      it{ expect( subject.a2 1 ).to eq [2] }
    end # context 'defines the aspect for all methods starting with a'
    context 'does not define the aspect for methods not starting with a' do 
      it{ expect( subject.b1 1 ).to eq [1] }
    end # context 'does not define the aspect for methods not starting with a'
  end # context 'cross concern (using param filter)'

  context 'cross concern (using param filter method)' do 
    before do
      class_under_test.new_method :bef_b, &:succ
      class_under_test.param_filter %r{\Ab\d}, :bef_b
    end
    context 'defines the aspect for all methods starting with b and a digit' do 
      it{ expect( subject.b1 1 ).to eq [2] }
    end # context 'defines the aspect for all methods starting with a'
    context 'does not define the aspect for methods not starting with b and a digit' do 
      it{ expect( subject.a1 1 ).to eq [1] }
      it{ expect( subject.a2 1 ).to eq [1] }
    end # context 'does not define the aspect for methods not starting with a'
  end # context 'cross concern (using param filter method)'

  context 'cross concern (mixing param filter blocks and methods)' do 
    before do
      class_under_test.param_filter %r{\Aa\d} do |c| c.succ  end
      
      class_under_test.new_method :tripple_c do |c| c*3 end
      class_under_test.param_filter %r{\A.1}, :tripple_c
    end

    context 'a1 triggers both, a2 triggers increment, b1 triggers trippling' do
      it{ expect( subject.a1 1 ).to eq [4] }
      it{ expect( subject.a2 1 ).to eq [2] }
      it{ expect( subject.b1 1 ).to eq [3] }
    end # context 'a1 triggers both, a2 triggers increment, b1 triggers doubling'
    
  end # context 'cross concern (mixing param filter blocks and methods)'
end # describe AOP
