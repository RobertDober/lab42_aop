require 'spec_helper'

describe AOP do
  context 'block filters simple after' do

    context 'no params' do
      before do
        class_under_test.new_method :main1 do
          @count
        end
        class_under_test.after :main1 do
          @count = 21
        end
      end
      it 'does not influence the result' do
        expect( subject.main1 ).to be_nil
      end
      it 'but has side effects' do
        subject.main1
        expect( subject.count ).to eq 21
      end
    end # context 'simple before'

    context 'with params' do
      before do
        class_under_test.new_method :main2 do |a|
          2 * @a + a
        end
        class_under_test.after :main2 do | a |
          @a = a
        end
        class_under_test.on_init{ @a = 20 }
      end
      it 'does not influence the result' do
        expect( subject.main2 2 ).to eq 42
      end
      it 'but has side effects' do
        subject.main2 42
        expect( subject.a ).to eq 42
      end
    end # context 'with params'
    context 'with params and blocks' do
      before do
        class_under_test.new_method :main3 do |a, &b|
          b.(@a||0)
        end
        class_under_test.after :main3 do | a, &b |
          @a = b.( a )
        end
      end
      it 'does not influence the result' do
        expect( subject.main3(0, &:zero?) ).to eq true
      end
      it 'but has side effects' do
        subject.main3(0, &:zero?)
        expect( subject.a ).to eq true
      end
    end # context 'with params'
  end # context 'block filters simple after'
end # describe AOP
