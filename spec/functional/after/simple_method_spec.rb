require 'spec_helper'

describe AOP do

  context 'method aspects, simple after' do 
    context 'no params' do 
      before do
        class_under_test.new_method :after1 do
          @count = 21
        end
        class_under_test.new_method :main1 do
          @count
        end
        class_under_test.after :main1, :after1
      end
      it{ expect( subject.main1 ).to be_nil }
      it{ expect( subject.main1 || subject.main1 ).to eq 21 }
    end # context 'simple before'

    context 'with params' do 
      before do
        class_under_test.new_method :after2 do |a|
          @a = @a + a
        end
        class_under_test.new_method :main2 do |a|
          @a = a 
        end
        class_under_test.after :main2, :after2
      end
      it 'does not change return val' do
        expect( subject.main2 21 ).to eq 21
      end
      it 'but it has its side effects' do
        subject.main2 21  
        expect( subject.a ).to eq 42
      end
    end # context 'with params'

    context 'with params and blocks' do 
      before do
        class_under_test.new_method :after3 do |a, &b|
          @a = b.(0)
        end
        class_under_test.new_method :main3 do |a, &b|
          b.(@a + a)
        end
        class_under_test.after :main3, :after3
        class_under_test.on_init{ @a = 21 }
      end
      it 'does not change return val' do
        expect( subject.main3( 20, &:succ) ).to eq 42
      end
      it 'but it has its side effects' do
        subject.main3(100, &:pred)
        expect( subject.a ).to eq -1
      end
    end # context 'with params and blocks'

  end # context 'method aspects, simple after'

end # describe AOP
