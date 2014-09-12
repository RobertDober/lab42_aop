require 'spec_helper'

describe AOP::Meta do
  subject do
    Object.new
  end

  it 'can define a singleton method' do
    described_class.add_singleton_method( subject, :alpha ){ 42 }
    expect( subject.alpha ).to eq 42
  end

  it 'returns the object' do
    expect( described_class.add_singleton_method( subject, :alpha ){42} ).to eq subject
  end
  
end # describe AOP::Meta
