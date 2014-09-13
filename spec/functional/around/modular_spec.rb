require 'spec_helper'

describe AOP do
  context 'around aspects with module concerns' do
    let( :mod1 ){ aop_module{
      def a1; end
      def b1; end
      private
      def x1; end
    } }

    let( :mod2 ){ aop_module{
      def a2; end
    } }

    let( :mod3 ){ aop_module{
      def b3; end
    }}

    before do
      mod3.send :include, mod1
      class_under_test.on_init{@b = []; @a = []} # b before, a after
      [mod1, mod2, mod3].each do |m|
        class_under_test.send :include, m
      end
    end

    context 'using the simplest module as a concern' do
      before do
        class_under_test.around mod1 do |concern|
          @b << concern.name.to_s
          concern.()
          @a << concern.name.to_s
        end
      end
      it 'concerns the module methods' do
        subject.a1
        expect( subject.b ).to eq %w{a1}
        expect( subject.a ).to eq %w{a1}
      end
      it 'but not the others' do
        class_under_test.null_methods :a3
        subject.a1
        subject.a3
        expect( subject.b ).to eq %w{a1}
        expect( subject.a ).to eq %w{a1}
      end
      it 'does not concern private methods' do
        subject.a1
        subject.b1
        subject.send :x1
        expect( subject.b ).to eq %w{a1 b1}
        expect( subject.a ).to eq %w{a1 b1}
      end
      it 'does not concern redefined methods either' do
        class_under_test.null_methods :a1
        subject.a1
        expect( subject.b ).to be_empty
        expect( subject.a ).to be_empty
      end
    end # context 'using the simplest module as a concern'

    context 'using a complex (including itself a module) as a concern' do
      before do
        class_under_test.new_method :around_mod3 do | concern |
          @b << concern.name.to_s
          concern.()
          @a << concern.name.to_s
        end
      end

      shared_examples_for 'default' do
        it 'counts the module methods' do
          subject.b3
          expect( subject.b ).to eq %w{b3}
          expect( subject.a ).to eq %w{b3}
        end
        it 'but not the deeply included ones' do
          subject.a1
          expect( subject.b ).to be_empty
          expect( subject.a ).to be_empty
        end
      end

      shared_examples_for 'including included' do
        it 'counts the module methods' do
          subject.b3
          expect( subject.b ).to eq %w{b3}
          expect( subject.a ).to eq %w{b3}
        end
        it 'and also the deeply included ones' do
          subject.a1
          expect( subject.b ).to eq %w{a1}
          expect( subject.a ).to eq %w{a1}
        end
      end

      context 'block aspect with default behavior' do
        before do
          class_under_test.around mod3 do |concern|
            @b << concern.name.to_s
            concern.()
            @a << concern.name.to_s
          end
        end
        it_behaves_like 'default'
      end # context 'with default behavior'

      context 'block aspect with include_include behavior' do
        before do
          class_under_test.around mod3, include_included: true do |concern|
            @b << concern.name.to_s
            concern.()
            @a << concern.name.to_s
          end
        end
        it_behaves_like 'including included'
      end # context 'with include_include behavior'

      context 'method aspect with default behavior' do
        before do
          class_under_test.around mod3, :around_mod3
        end
        it_behaves_like 'default'
      end # context 'method aspect with default behavior'

      context 'method aspect with include_include behavior' do
        before do
          class_under_test.around mod3, :around_mod3, include_included: true
        end
        it_behaves_like 'including included'
      end # context 'method aspect with include_include behavior'
    end # context 'using a complex (including itself a module) as a concern'

  end # context 'around aspects with module concerns'
end # describe AOP
