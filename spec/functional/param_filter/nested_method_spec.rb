require 'spec_helper'

describe AOP do
  context 'method filters, nested param filter' do

    context 'single param' do
      before do
        class_under_test.new_method :filter1 do | a |
          2 * a
        end
        class_under_test.new_method :filter2 do | a |
          a.succ
        end
        class_under_test.new_method :main1 do | a |
          a.succ
        end
        class_under_test.param_filter :main1, [:filter1, :filter2]
      end
      it{ expect( subject.main1 1 ).to eq 5 }
    end # context 'single param'

    context 'multiple params' do
      before do
        class_under_test.new_method :filter1 do | *a |
          a.reject(&:odd?)
        end
        class_under_test.new_method :filter2 do | *a |
          a.map(&:succ)
        end
        class_under_test.new_method :main2 do | *a |
          a.join
        end
        class_under_test.param_filter :main2, :filter2
        class_under_test.param_filter :main2, :filter1
      end
      it{ expect( subject.main2 2, 3, 4 ).to eq "35" }
    end # context 'multiple params'

    context 'blox are not touched, geometry can be changed' do 
      before do
        class_under_test.new_method :filter4 do | a, b |
          [a + b,a - b]
        end
        class_under_test.new_method :filter5 do |a, b|
          a + b
        end
        class_under_test.new_method :main4 do | a, &blk |
          blk.( a )
        end
        class_under_test.param_filter :main4, [:filter5, :filter4]
      end
      it{ expect( subject.main4( 1, 2 ){|x| 10*x } ).to eq 20  }
    end # context 'blox are not touched'
  end # context 'method filters, nested param filter'
end
