require 'spec_helper'
require 'lab42/aop/version'

describe Lab42::AOP do 
  context 'VERSION' do 
    it 'is semantic' do
      expect( described_class::VERSION ).to match %r{\A(\d+)\.(\d+)(?:\.(\d+)(?:[.-]pre-?\d*)?)?\z}
    end
  end # context 'VERSION'
end # describe Lab42::AOP::Version
