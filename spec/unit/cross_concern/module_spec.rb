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

    it 'gets only publicly declared modules' do
      expect( mthd.(mod, mod) ).to eq mk_concerns( mod, :a1, :a2, :b1 )
    end

    context 'included modules' do 
      before do
        mod.send :include, Module.new{
          def x1; end
        } 
      end
      it 'does not get any methods included from others' do
        expect( mthd.(mod, mod) ).to eq mk_concerns( mod, :a1, :a2, :b1 )
      end
      it 'unless we say so' do
        expect( mthd.(mod, mod, include_included: true) ).to eq mk_concerns( mod, :a1, :a2, :b1, :x1 )
      end
      it 'but we can still exclude one method' do
        expect( mthd.(mod, mod, include_included: true, exclude: :a1 ) ).to eq mk_concerns( mod, :a2, :b1, :x1 )
      end

    end # context 'included modules'
  end # context 'module'

end # describe AOP::CrossConcern
