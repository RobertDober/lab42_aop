require 'spec_helper'

describe AOP do
  context 'nested mixed result filters' do
    before do
      class_under_test.new_method :double do |n, &b|
        n * b.(2)
      end
      class_under_test.new_method :double_again do |r, &b|
        r * b.(2)
      end
      class_under_test.result_filter :double, :double_again
      class_under_test.result_filter :double do | r, &b |
        b.( r.succ )
      end
    end



    it 'transforms the result correctly' do
      expect( subject.double(1){|x| x * 2} ).to eq 34
    end

  end # context 'nested mixed result filters'

end # describe AOP
