require 'spec_helper'

describe AOP, :wip do
  context 'after aspects with module concerns' do 
    let( :mod1 ){ aop_module{
      def a1; end
      def b1; end
    } }

    let( :mod2 ){ aop_module{
      def a2; end
    } }
    
    let( :mod3 ){ aop_module{
      def b3; end
    }}
    
    before do

      mod3.send include mod1
      class_under_test.on_init{@l = []} # l like logs
      [mod1, mod2, mod3].each do |m|
        class_under_test.send :include, m
      end
    end

    
  end # context 'after aspects with module concerns'
end # describe AOP
