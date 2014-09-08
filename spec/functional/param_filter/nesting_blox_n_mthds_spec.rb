require 'spec_helper'

describe AOP do 

  context 'mixed filters, nesting blox and methods' do
    before do
      class_under_test.new_method :main do | a, &b |
        b.( a )
      end
      class_under_test.new_method :filter do | *args |
        args.reduce :+
      end
    end

    context 'method first' do 
      before do
        class_under_test.param_filter :main do | sum |
          2 * sum
        end
        class_under_test.param_filter :main, :filter
      end
      it{ expect( subject.main(*0..9,&[:*,2]) ).to eq 180 }
    end # context 'method first'
    
    context 'block first' do 
      before do
        class_under_test.param_filter :main, :filter
        class_under_test.param_filter :main do | *a |
          a.reject(&:odd?)
        end
      end
      it{ expect( subject.main(*0..9,&[:*,2]) ).to eq 40 }
    end # context 'block first'
  end # context 'mixed filters, nesting blox and methods'
  
end # describe AOP
