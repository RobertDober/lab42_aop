require 'spec_helper'

describe AOP do
  context 'block filters, nested param filter' do

    context 'single param' do
      before do
        class_under_test.new_method :main1 do | a |
          a.succ
        end
        class_under_test.param_filter :main1 do | a |
          2 * a
        end
        class_under_test.param_filter :main1 do | a |
          a.succ
        end
      end
      it{ expect( subject.main1 1 ).to eq 5 }
    end # context 'single param'

    context 'multiple params' do
      before do
        class_under_test.new_method :main2 do | *a |
          a.join
        end
        class_under_test.param_filter :main2 do | *a |
          a.map(&[:*, 2])
        end
        class_under_test.param_filter :main2 do | *a |
          a.map(&:succ)
        end
      end
      it{ expect( subject.main2 2, 3, 4 ).to eq "6810" }
    end # context 'multiple params'


    context 'blox are not touched, geometry can be changed' do
      before do
        class_under_test.new_method :main3 do | a, &blk |
          blk.( a )
        end
        class_under_test.param_filter :main3 do | a, b |
          a + b
        end
        class_under_test.param_filter :main3 do | a |
          [a, a.succ ]
        end
      end
      it{ expect( subject.main3( 1 ){|x| 10*x } ).to eq 30  }
    end # context 'blox are not touched'
  end # context 'block filters, nested param filter'
end # describe AOP
