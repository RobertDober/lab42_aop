require 'spec_helper'

describe AOP do
  context 'nesting blox and methods in after' do

    context 'no params' do
      before do
        class_under_test.new_method :after1 do
          @a *= 2
        end
        class_under_test.new_method :main1 do
          @a = 10
        end # class_under_test.new_method :main1
      end
      context 'blk after method' do
        before do
          class_under_test.after :main1, :after1
          class_under_test.after :main1 do
            @a += 1
          end
        end
        it 'does not influence result' do
          expect( subject.main1 ).to eq 10
        end
        it 'has side effects (in definition order)' do
          subject.main1
          expect( subject.a ).to eq 21
        end
      end # context 'blk before method'
      context 'method before blk' do
        before do
          class_under_test.after :main1 do
            @a += 1
          end
          class_under_test.after :main1, :after1
        end
        it 'does not influence result' do
          expect( subject.main1 ).to eq 10
        end
        it 'has side effects (in definition order)' do
          subject.main1
          expect( subject.a ).to eq 22
        end
      end # context 'method before blk'
    end # context 'no params'

    context 'with params' do
      before do
        class_under_test.new_method :main2 do |a|
          @a = a
        end
        class_under_test.new_method :after2 do |a|
          @a += a
        end
      end
      context 'blk before method' do
        before do
          class_under_test.after :main2, :after2
          class_under_test.after :main2 do |a|
            @a *= a
          end
        end
        it 'does not influence result' do
          expect( subject.main2 10 ).to eq 10
        end
        it 'has side effects (in definition order)' do
          subject.main2 3
          expect( subject.a ).to eq 18
        end
      end # context 'blk before method'
      context 'method before blk' do
        before do
          class_under_test.after :main2 do |a|
            @a *= a
          end
          class_under_test.after :main2, :after2
        end
        it 'does not influence result' do
          expect( subject.main2 10 ).to eq 10
        end
        it 'has side effects (in definition order)' do
          subject.main2 3
          expect( subject.a ).to eq 12
        end
      end # context 'method before blk'
    end # context 'with params'

    context 'with params and blk' do
      before do
        class_under_test.new_method :after3 do |a,&b|
          @a += b.( a )
        end
        class_under_test.new_method :main3 do |a,&b|
          @a = b.( a )
        end
      end
      context 'blk after method' do
        before do
          class_under_test.after :main3, :after3
          class_under_test.after :main3 do |a,&b|
            @a *= b.( a )
          end
        end
        it 'does not influence result' do
          expect( subject.main3 1, &[:*, 2] ).to eq 2
        end
        it 'has side effects (in definition order)' do
          subject.main3 1, &[:*, 2]
          expect( subject.a ).to eq 8
        end
      end # context 'blk before method'
      context 'method after blk' do
        before do
          class_under_test.after :main3 do |a,&b|
            @a *= b.( a )
          end
          class_under_test.after :main3, :after3
        end
        it 'does not influence result' do
          expect( subject.main3 1, &[:*, 2] ).to eq 2
        end
        it 'has side effects (in definition order)' do
          subject.main3 1, &[:*, 2]
          expect( subject.a ).to eq 6
        end
      end # context 'method before blk'
    end # context 'with params and blk'
  end # context 'nesting blox and methods in after'
end # describe AOP
