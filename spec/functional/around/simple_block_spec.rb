require 'spec_helper'

describe AOP do

  context 'simple, block based, around aspect' do 
    before do
      class_under_test.new_method :main do |a| @a += a end
      class_under_test.around :main do |concern, a|
        @a = 0
        concern.( a )
        @a += 1
      end
    end
    it 'returns the consern\'s result' do
      expect( subject.main 41 ).to eq 41
    end
    it 'runs the around code' do
      subject.main 41
      expect( subject.a ).to eq 42
    end

    context 'aspects store results of concerns correctly' do 
      let( :capture ){ double "capture" }
      before do
        capt = capture
        class_under_test.new_method :a1 do 1 end
        class_under_test.new_method :a2 do 2 end
        class_under_test.new_method :a3 do 3 end
        class_under_test.around %r{\Aa\d} do |concern|
          capt.before
          concern.()
          capt.after
        end
      end # context 'aspects store results of concerns correct'
      it 'calls all aspects and returns all results' do
        3.times do
          expect( capture ).to receive(:before).ordered
          expect( capture ).to receive(:after).ordered
        end
        expect( subject.a1 ).to eq 1
        expect( subject.a2 ).to eq 2
        expect( subject.a3 ).to eq 3
      end
    end # context 'aspects store results od concerns correctly'
  end # context 'simple, block based, around aspect'


end # describe AOP
