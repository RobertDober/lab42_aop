require 'spec_helper'

describe AOP do
  context 'result filter aspects with module concerns' do 
    let( :mod1 ){ aop_module{
      def a1 a; a.succ end
      def b1 b; 2*b end
    } }

    let( :mod2 ){ aop_module{
      def b3 b; 3*b end
    }}

    before do
      mod2.send :include, mod1
      class_under_test.send :include, mod2
      class_under_test.new_method :x do |a| a end
    end

    context 'using the simplest module as concern' do
      before do
        class_under_test.result_filter mod1 do |*args|
          args.first.succ
        end
      end
      it 'filters the module\'s method' do
        expect( subject.a1 0 ).to eq 2
      end
      it 'but the other module\'s one not so much' do
        expect( subject.b3 1 ).to eq 3
      end
    end # context 'using the simplest module as concern'

    context 'using the complex module as concern' do
      before do
        class_under_test.result_filter mod2 do |*args|
          args.first.succ
        end
      end
      it 'filters the module\'s method' do
        expect( subject.b3 1 ).to eq 4
      end
      it 'but the sub module\'s one not so much' do
        expect( subject.a1 0 ).to eq 1
      end
    end # context 'using the complex module as concern'

    context 'using the complex module as concern (with include included)' do 
      shared_examples_for 'including included' do
        it 'filters the module\'s method' do
          expect( subject.b3 1 ).to eq 4
        end
        it 'and the sub module\'s one too' do
          expect( subject.a1 0 ).to eq 2
        end
      end

      context 'method' do 
        before do
          class_under_test.new_method :filter do |*a|
            a.first.succ
          end
          class_under_test.result_filter mod2, :filter, include_included: true
        end
        it_behaves_like 'including included'
      end # context 'method'
      context 'block' do 
        before do
          class_under_test.result_filter mod2, include_included: true do |*a|
            a.first.succ
          end
        end
        it_behaves_like 'including included'
      end # context 'method'
    end

  end # context 'result filter aspects with module concerns'
end # describe AOP
