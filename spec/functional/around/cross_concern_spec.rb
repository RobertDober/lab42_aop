require 'spec_helper'

describe AOP do

  before do
    class_under_test.null_methods :a1, :a2, :b1
    class_under_test.on_init{ @b = []; @a = [] }  # b before, a after
  end

  context 'cross concern (using around block)' do
    before do
      class_under_test.around %r{\Aa} do |concern|
        @b << concern.name
        concern.()
        @a << concern.name
      end
    end

    context 'defines the aspect for all methods starting with a' do
      it{ subject.a1; subject.a2
          expect( subject.b  ).to eq [:a1, :a2]
          expect( subject.a  ).to eq [:a1, :a2]
      }
    end # context 'defines the aspect for all methods starting with a'
    context 'does not define the aspect for methods not starting with a' do
      it{ subject.b1
          expect( subject.b ).to be_empty
          expect( subject.a ).to be_empty
      }
    end # context 'does not define the aspect for methods not starting with a'
  end # context 'cross concern (using around)'

  context 'cross concern (using around method)' do
    before do
      class_under_test.new_method :bef_b do |concern|
        @b << concern.name
        concern.()
        @a << concern.name
      end
      class_under_test.around %r{\Ab\d}, :bef_b
    end
    context 'defines the aspect for all methods starting with b' do
      it{
        subject.b1
        expect( subject.b  ).to eq [:b1]
        expect( subject.a  ).to eq [:b1]
      }
    end # context 'defines the aspect for all methods starting with b'
    context 'does not define the aspect for methods not starting with b' do
      it{
        subject.a1; subject.a2
        expect( subject.b ).to be_empty
        expect( subject.a ).to be_empty
      }
    end # context 'does not define the aspect for methods not starting with b'
  end # context 'cross concern (using around method)'

  context 'cross concern (mixing around blocks and methods)' do
    before do
      class_under_test.around %r{\Aa\d} do | concern |
        @b << concern.name
        concern.()
        @a << concern.name
      end

      class_under_test.new_method :around_m do | concern |
        @b << 1
        concern.()
        @a << 2
      end
      class_under_test.around %r{\A.1}, :around_m
    end

    context 'a1 triggers both, a2 triggers increment, b1 triggers trippling' do
      it 'a2 triggers block aspect' do
        subject.a2
        expect( subject.b ).to eq [:a2]
        expect( subject.a ).to eq [:a2]
      end
      it 'b1 triggers method aspect' do
        subject.b1
        expect( subject.b ).to eq [1]
        expect( subject.a ).to eq [2]
      end
      it 'a1 triggers both' do
        subject.a1
        expect( subject.b ).to eq [1, :a1]
        expect( subject.a ).to eq [:a1, 2]
        
      end
    end # context 'a1 triggers both, a2 triggers increment, b1 triggers doubling'

  end # context 'cross concern (mixing around blocks and methods)'
end # describe AOP
