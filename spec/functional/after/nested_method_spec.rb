require 'spec_helper'

describe AOP do
  context 'method aspects, nested after' do

    context 'no params' do
      before do
        class_under_test.new_method :main1 do
          @count ||= 1
        end
        class_under_test.new_method :after11 do
          @count *= 2
        end
        class_under_test.new_method :after12 do
          @count += 1
        end
        class_under_test.after :main1, [:after11, :after12] # (* Good ol Pascal comments *)
      end
      it 'has no effects on result' do
        expect( subject.main1 ).to eq 1
      end
      it 'has side effects (executed in definition order)' do
        subject.main1
        expect( subject.count ).to eq 3
      end
    end # context 'simple before'

    context 'with params' do
      before do
        class_under_test.new_method :main2 do | a |
          @a = a
        end
        class_under_test.new_method :after21 do | a |
          @a += 1
        end
        class_under_test.new_method :after22 do | a |
          @a *= a
        end
        class_under_test.after :main2, [:after21, :after22]
      end
      it 'has no effects on result' do
        expect( subject.main2 1 ).to eq 1
      end
      it 'has side effects' do
        subject.main2 2
        expect( subject.a ).to eq 6
      end
    end # context 'with params'

    context 'with params and blocks' do
      before do
        class_under_test.new_method :main3 do |a, &b|
          @a = b.( a )
        end
        class_under_test.new_method :after31 do | a, &b |
          @a += b.( a )
        end
        class_under_test.new_method :after32 do | a, &b |
          @a *= b.( a )
        end
        class_under_test.after :main3, [:after31, :after32]
      end
      it 'has no effects on result' do
        expect( subject.main3 1, &[:*, 2] ).to eq 2
      end
      it 'has side effects' do
        subject.main3 1,&[:*, 2]
        expect( subject.a ).to eq 8
      end
    end # context 'with params'

  end # context 'block aspects nested after'
end # describe AOP
