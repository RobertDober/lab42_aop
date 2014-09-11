require 'spec_helper'

describe AOP do

  before do
    class_under_test.null_methods :a1, :a2, :b1
    class_under_test.on_init{ @c=1 }
  end

  context 'cross concern (using after block)' do
    before do
      class_under_test.after %r{\Aa} do @c += 1 end
    end

    context 'defines the aspect for all methods starting with a' do
      it{ subject.a1; subject.a2;  expect( subject.c  ).to eq 3 }
    end # context 'defines the aspect for all methods starting with a'
    context 'does not define the aspect for methods not starting with a' do
      it{ subject.b1; expect( subject.c ).to eq 1 }
    end # context 'does not define the aspect for methods not starting with a'
  end # context 'cross concern (using after)'

  context 'cross concern (using after method)' do
    before do
      class_under_test.new_method :bef_b do @c+= 1 end
      class_under_test.after %r{\Ab\d}, :bef_b
    end
    context 'defines the aspect for all methods starting with b and a digit' do
      it{ subject.b1; expect( subject.c ).to eq 2 }
    end # context 'defines the aspect for all methods starting with a'
    context 'does not define the aspect for methods not starting with b and a digit' do
      it{ subject.a1; subject.a2; expect( subject.c ).to eq 1 }
    end # context 'does not define the aspect for methods not starting with a'
  end # context 'cross concern (using after method)'

  context 'cross concern (mixing after blocks and methods)' do
    before do
      class_under_test.after %r{\Aa\d} do @c += 1 end

      class_under_test.new_method :tripple_c do @c *= 3 end
      class_under_test.after %r{\A.1}, :tripple_c
    end

    context 'a1 triggers both, a2 triggers increment, b1 triggers trippling' do
      it{ subject.a1; expect( subject.c ).to eq 6 }
      it{ subject.a2; expect( subject.c ).to eq 2 }
      it{ subject.b1; expect( subject.c ).to eq 3 }
    end # context 'a1 triggers both, a2 triggers increment, b1 triggers doubling'

  end # context 'cross concern (mixing after blocks and methods)'
end # describe AOP
