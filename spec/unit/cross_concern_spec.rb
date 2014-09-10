require 'spec_helper'
require 'ostruct'

describe AOP::CrossConcern do

  before do
    class_under_test.null_methods :a1, :a2, :b1
  end
  let( :klass ){ class_under_test }
  
  def mk_concern cls, name
    OpenStruct.new cls: cls, name: name, mthd: cls.instance_method( name )
  end

  def mk_concerns cls, *names
    names.map{ |name| mk_concern cls, name }
  end
  

  context 'methods from symbols' do 
    
    it 'can be empty' do
      expect( described_class.get_methods klass, [:a3] ).to be_empty
    end
    it 'or not' do
      expect( described_class.get_methods klass, [:a2] ).to eq mk_concerns( klass, :a2 )
    end
    it 'eliminates non existing methods from the list' do
      expect( described_class.get_methods klass, [:a2, :x] ).to eq mk_concerns( klass, :a2 )
    end

  end # context 'methods from symbols'

  context 'methods from strings' do 
    it 'finds methods containing the string as a substring' do
      expect( described_class.get_methods klass, %w{1} ).to eq mk_concerns( klass, :a1, :b1 )
    end
    it 'and also for more strings' do
      expect( described_class.get_methods klass, %w{1 2 1} ).to eq mk_concerns( klass, :a1, :b1, :a2 )
    end
  end # context 'methods from strings'

  context 'methods from rgx' do 
    it 'finds methods according to the rgx' do
      expect( described_class.get_methods klass, [%r{\Aa\d}] ).to eq mk_concerns( klass, :a1, :a2 )
    end
  end # context 'methods from rgx'
  
end # describe AOP::CrossConcern
