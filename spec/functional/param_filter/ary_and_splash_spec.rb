require 'spec_helper'

describe AOP do

  context 'param filters when' do
    before do
      class_under_test.new_method :main1 do | a |
        a
      end
      class_under_test.send :alias_method, :main2, :main1
      class_under_test.send :alias_method, :main3, :main1

      class_under_test.param_filter :main1 do | a |
        [a + a]
      end
      class_under_test.param_filter :main2 do | *a |
        [a + a]
      end
      class_under_test.param_filter :main3 do | *a |
        a + a
      end
    end

    context 'filter has normal param (arity 1) and returns wrapper' do
      it 'wrapper is removed' do
        expect( subject.main1( %w{a b c} ) ).to eq %w{a b c a b c}
      end
    end # context 'filter is normal param, returns wrapper'

    context 'filter has splat param (arity -1) and returns wrapper' do
      it 'wrappes the array when called in 1 param form' do
        expect( subject.main2 %w{a b c} ).to eq [%w{a b c}, %w{a b c}]
      end
      it 'removes wrapper if called in n param form' do
        expect( subject.main2( *%w{a b c} ) ).to eq %w{a b c a b c}
      end
    end # context 'filter has splat param and returns wrapper'

    context 'filter has splat param (arity -1) and returns value' do
      it 'passes on normally if called in 1 param form' do
        expect{ subject.main3( %w{a b c} ) }.to raise_error ArgumentError, /\(2 for 1\)/
      end
      it 'loses a level and calls the next filter with expanded params' do
        expect{ subject.main3( *%w{a b c} ) }.to raise_error ArgumentError, /\(6 for 1\)/
      end
    end # context 'filter has splat param (arity -1) and returns wrapper'
  end # context 'param filters, passing params as splat'

end # describe AOP
