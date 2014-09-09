require 'spec_helper'

describe AOP do
  context 'filter result with methods' do 

    context 'params for filter is the result' do 
      before do
        class_under_test.new_method :one do 1 end
        class_under_test.new_method :inc do |a| a.succ end
        class_under_test.result_filter :one, :inc
      end
      it 'transforms the result' do
        expect( subject.one ).to eq 2 # sic!
      end
    end # context 'without params'

    context 'additional params are still sent' do 
      before do
        class_under_test.new_method :double do |n| n * 2 end
        class_under_test.new_method :inc_with_params do |a, *params| a + params.reduce( :+ ) end
        class_under_test.result_filter :double, :inc_with_params
      end
      it 'transforms the result with the orig params' do
        expect( subject.double 14 ).to eq 42
      end
    end # context 'additional params are still sent'

    context 'additional params are still sent and so is a block' do 
      before do
        class_under_test.new_method :double do |n, &b| b.( n ) * 2 end
        class_under_test.new_method :inc_with_params_and_block do |r, *params, &b|
          r + b.( params.reduce( :+ ) )
        end
        class_under_test.result_filter :double, :inc_with_params_and_block
      end
      it 'transforms the result with the orig params' do
        expect( subject.double 7, &[:*,2] ).to eq 42
      end
    end # context 'additional params are still sent'

  end # context 'filter result with methods'
end # describe AOP
