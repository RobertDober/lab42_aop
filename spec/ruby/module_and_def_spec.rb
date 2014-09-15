
#
# We are not testing ruby, just savegarding againts language changes
#

describe Module do 
  context 'include does not redefine method' do 
    let( :mod ){ Module.new{ def a; :module end } }
    let( :klass ){ Class.new{ def a; :klass end } }
    before do
      klass.send :include, mod
    end
    it{ expect( klass.new.a ).to eq :klass }
  end # context 'include does not redefine method'
  context 'include does not redefine method even if defined by module_eval' do 
    let( :mod ){ Module.new{ def a; :module end } }
    let :klass do
      definition_block = ->(*args){ def a; :block end }
      Class.new{ module_eval &definition_block }
    end
    before do
      klass.send :include, mod
    end
    it{ expect( klass.new.a ).to eq :block }
  end # context 'include does not redefine method'
  context 'include does indeed redefine method defined by block' do 
    let( :mod ){ Module.new{ def a; :module end } }
    let :klass do
      definition_block = ->(*args){ def a; :block end }
      Class.new{ definition_block.() }
    end
    before do
      klass.send :include, mod
    end
    it{ expect( klass.new.a ).to eq :module }
  end # context 'include does not redefine method'
end # describe Module
