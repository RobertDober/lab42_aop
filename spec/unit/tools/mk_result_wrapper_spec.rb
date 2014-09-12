require 'spec_helper'

class Adder
  def add n
    n + @a
  end
  def initialize a=1
    @a = a
  end
end # class Adder

describe AOP::Tools do
  
  it 'has a name' do
    expect( described_class.mk_result_wrapper(Adder.new.method( :add ), :adding).name ).to eq :adding
  end

  it 'wraps results' do
    w = described_class.mk_result_wrapper Adder.new(40).method(:add), :add40
    w.(2)
    expect( w.result ).to eq 42
  end

  it 'is purely functional' do
    w = described_class.mk_result_wrapper Adder.new(40).method(:add), :add40
    w.(1)
    w.(2)
    expect( w.result ).to eq 42
    
  end


  
end # describe AOP::Tools
