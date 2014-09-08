require 'spec_helper'

describe AOP do
  context 'block filters, nested before' do 

    context 'no params' do
      before do
        class_under_test.new_method :main1 do
          @count
        end
        class_under_test.before :main1 do
          @count *= 2
        end
        class_under_test.before :main1 do
          @count = 21
        end
      end
      it{ expect( subject.main1 ).to eq 42 }
    end # context 'simple before'

    context 'with params' do
      before do
        class_under_test.new_method :main2 do |a|
          @a + a
        end
        class_under_test.before :main2 do | a |
          @a += a
        end
        class_under_test.before :main2 do | a |
          @a = a
        end
      end
      it{ expect( subject.main2 1 ).to eq 3 }
    end # context 'with params'
    context 'with params, and blocks' do 
      before do
        class_under_test.new_method :main3 do |a, &b|
          b.(2 * @a + a) # (3) @a <- 20210
        end
        class_under_test.before :main3 do | a, &b |
          @a = b.( 10*@a + a ) # (2) @a <- 1010
        end
        class_under_test.before :main3 do | a, &b |
          @a = b.( a ) # (1) @a <- 10
        end
      end
      it{ expect( subject.main3(1){|a| 10*a} ).to eq 20210 }
    end # context 'with params'

  end # context 'block filters'
end # describe AOP
