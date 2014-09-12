require 'spec_helper'

describe AOP::CrossConcern do

  context 'module' do 
    let( :mod ) { 
      Module.new do
        def a1; end
        def a2; end
        def b1; end
        private
        def p1; end
      end
    }
    let( :mthd ){ ->( kls, mth, **kwds ){described_class.get_methods kls, [mth], **kwds } }

    before do
      mod.send :include, Module.new{ def c1; end }
    end
    it 'gets only publicly declared modules' do
      expect( mthd.(mod, mod) ).to eq mk_concerns( mod, :a1, :a2, :b1 )
    end

    context 'included modules' do 
      it 'does not get any methods included from others' do
        expect( mthd.(mod, mod) ).to eq mk_concerns( mod, :a1, :a2, :b1 )
      end
      it 'unless we say so' do
        expect( mthd.(mod, mod, include_included: true) ).to eq mk_concerns( mod, :a1, :a2, :b1, :c1 )
      end
      it 'but we can still exclude one method' do
        expect( mthd.(mod, mod, include_included: true, exclude: :a1 ) ).to eq mk_concerns( mod, :a2, :b1, :c1 )
      end

    end # context 'included modules'

    context 'using an included module' do
      before do
        class_under_test.send :include, mod
      end
      it 'sees included methods' do
        expect( mthd.( class_under_test, mod ) ).to eq mk_concerns( class_under_test, :a1, :a2, :b1 )
      end
      it 'can eliminate some with exclude' do
        expect( mthd.( class_under_test, mod, exclude: %r{\Aa} ) ).to eq mk_concerns( class_under_test, :b1 )
      end
      context 'including itself a module' do 
        it 'can concern the deeply included methods' do
          expect( mthd.( class_under_test, mod, include_included: true ) ).to eq mk_concerns( class_under_test, :a1, :a2, :b1, :c1 )
        end
        it 'or not' do
          expect( mthd.( class_under_test, mod, include_included: false ) ).to eq mk_concerns( class_under_test, :a1, :a2, :b1 )
          expect( mthd.( class_under_test, mod ) ).to eq mk_concerns( class_under_test, :a1, :a2, :b1 )
        end
        it 'can include them but also exlcude them again' do
          expect( mthd.( class_under_test, mod, include_included: true, exclude: /1/ ) )
            .to eq mk_concerns( class_under_test, :a2 )
          
        end
      end # context 'including itself a module'
    end # context 'it does only allow the self module'

  end # context 'module'

end # describe AOP::CrossConcern
