require 'spec_helper'

describe AOP do 
  context 'nesting blox and methods in before' do

    context 'no params' do 
      before do
        class_under_test.new_method :before1 do
          @a ||= 10
          @a *= 2
        end
        class_under_test.new_method :main1 do
          @a *= 10
        end # class_under_test.new_method :main1
      end
      context 'blk before method' do
        before do
          class_under_test.before :main1, :before1
          class_under_test.before :main1 do
            @a = 1
          end
        end
        it{ expect( subject.main1 ).to eq 20 }
      end # context 'blk before method'
      context 'method before blk' do 
        before do
          class_under_test.before :main1 do
            @a *= 3
          end
          class_under_test.before :main1, :before1
        end
        it{ expect( subject.main1 ).to eq 600 }
      end # context 'method before blk'
    end # context 'no params'

    context 'with params' do
      before do
        class_under_test.new_method :before1 do |a|
          @a ||= 10
          @a *= a
        end
        class_under_test.new_method :main1 do |a|
          @a *= 10
          @a += a
        end # class_under_test.new_method :main1
      end
      context 'blk before method' do
        before do
          class_under_test.before :main1, :before1
          class_under_test.before :main1 do |a|
            @a = a
          end
        end
        it{ expect( subject.main1 1 ).to eq 11 }
      end # context 'blk before method'
      context 'method before blk' do 
        before do
          class_under_test.before :main1 do |a|
            @a *= a
          end
          class_under_test.before :main1, :before1
        end
        it{ expect( subject.main1 1 ).to eq 101 }
      end # context 'method before blk'
    end # context 'with params'

    context 'with params and blk' do
      before do
        class_under_test.new_method :before1 do |a,&b|
          @a ||= b.( a )
        end
        class_under_test.new_method :main1 do |a,&b|
          b.(@a)
        end # class_under_test.new_method :main1
      end
      context 'blk before method' do
        before do
          class_under_test.before :main1, :before1
          class_under_test.before :main1 do |a,&b|
            @a ||= 10*b.(a) 
          end
        end
        it{ expect( subject.main1( 1 ){|x| 2*x } ).to eq 40 }
      end # context 'blk before method'
      context 'method before blk' do 
        before do
          class_under_test.before :main1 do |a,&b|
            @a ||= 10*b.(a) 
          end
          class_under_test.before :main1, :before1
        end
        it{ expect( subject.main1( 1 ){|x| 2*x }).to eq 4 }
      end # context 'method before blk'
    end # context 'with params and blk'
  end # context 'nesting blox and methods in before'
end # describe AOP
