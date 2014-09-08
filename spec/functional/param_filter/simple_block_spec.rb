require 'spec_helper'

describe AOP do
  context 'block filters, simple param filter' do

    context 'single param' do
      before do
        class_under_test.new_method :main1 do | a |
          a.succ
        end
        class_under_test.param_filter :main1 do | a |
          2 * a
        end
      end
      it{ expect( subject.main1 1 ).to eq 3 }
    end # context 'single param'

    context 'multiple params' do
      before do
        class_under_test.new_method :main2 do | *a |
          a.join
        end
        class_under_test.param_filter :main2 do | *a |
          @a = true
          a.reverse
        end
      end
      it{ expect( subject.main2 2, 3, 4 ).to eq "432" }
      it 'does not allow for side effects' do
        expect( subject.instance_variable_get :@a ).to be_nil
      end
    end # context 'multiple params'

    context 'mixture of params (kwds too)' do
      before do
        class_under_test.new_method :main3 do | *a, required:, optional: false |
          optional ? a : a.map(&:succ)
        end
        class_under_test.param_filter :main3 do | *a |
          kwds, pos = a.partition{|e| Hash === e }
          pos.reverse + kwds
        end
      end
      it{ expect( subject.main3 1, 2, 3, required: nil ).to eq [4,3,2] }
      it{ expect( subject.main3 1, 2, 3, required: nil, optional: true ).to eq [3,2,1] }
    end # context 'mixture of params (kwds too)'

    context 'blox are not touched, geometry can be changed' do 
      before do
        class_under_test.new_method :main4 do | a, &blk |
          blk.( a )
        end
        class_under_test.param_filter :main4 do | a, b |
          a + b
        end
      end
      it{ expect( subject.main4( 1, 2 ){|x| 10*x } ).to eq 30  }
    end # context 'blox are not touched'
  end # context 'block filters, simple param filter'
end # describe AOP
