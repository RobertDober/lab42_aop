require 'spec_helper'

describe AOP do
  context 'block filters, simple before' do

    context 'no params' do 
      before do
        class_under_test.new_method :main1 do
          2 * @count
        end
        class_under_test.before :main1 do
          @count = 21
        end
      end
      it 'is called correctly' do
        expect( subject.main1 ).to eq 42
      end
    end # context 'simple before'

    context 'with params' do 
      before do
        class_under_test.new_method :main2 do |a|
          2 * @a + a
        end
        class_under_test.before :main2 do | a |
          @a = a
        end
      end
      it 'is called correctly' do
        expect( subject.main2 1 ).to eq 3
      end
    end # context 'with params'
    context 'with params, and blocks' do 
      before do
        class_under_test.new_method :main3 do |a, &b|
          b.(2 * @a + a)
        end
        class_under_test.before :main3 do | a, &b |
          @a = b.( a )
        end
      end
      it 'is called correctly' do
        expect( subject.main3(1){|a| 10*a} ).to eq 210
      end
    end # context 'with params'
  end # context 'block filters, simple before'
end # describe AOP
