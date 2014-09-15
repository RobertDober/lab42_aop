require 'spec_helper'

describe AOP, :next do
  context 'scoped concerns' do 
    before do
      class_under_test.new_method :a1 do |a| @a=a end
      class_under_test.module_eval do
        concern_scope :b do
          def b1 a
            @a = a
          end
          after self do |*args|
            @a *= 2
          end
        end
      end
    end
    it 'concerns the scoped method' do
      subject.b1 1
      expect( subject.a ).to eq 2
    end
    it 'does not concern the outer method' do
      subject.a1 1
      expect( subject.a ).to eq 1
    end
  end # context 'scoped concerns'
end # describe AOP
