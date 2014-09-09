require 'spec_helper'

describe AOP do
  context 'method aspects, simple before' do 

    context 'no params' do 
      before do
        class_under_test.new_method :before1 do
          @count = 21
        end
        class_under_test.new_method :main1 do
          2 * @count
        end
        class_under_test.before :main1, :before1
      end
      it{ expect( subject.main1 ).to eq 42 }
    end # context 'simple before'

    context 'with params' do 
      before do
        class_under_test.new_method :before2 do |a|
          @a = a
        end
        class_under_test.new_method :main2 do |a|
          2 * @a + a
        end
        class_under_test.before :main2, :before2
      end
      it{ expect( subject.main2 1 ).to eq 3 }
    end # context 'with params'
    context 'with params, and blocks' do 
      before do
        class_under_test.new_method :before3 do |a, &b|
          @a = b.(a) 
        end
        class_under_test.new_method :main3 do |a, &b|
          b.(2 * @a + a)
        end
        class_under_test.before :main3, :before3
      end
      it{ expect( subject.main3(1){|a| 10*a} ).to eq 210 }
    end # context 'with params'
  end # context 'method filters'
end # describe AOP
