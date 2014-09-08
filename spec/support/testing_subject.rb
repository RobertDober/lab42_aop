
class Class
  alias_method :new_method, :define_method
  public :new_method
end

RSpec.configure do | c |
  c.before do
  self.class.subject do
    class_under_test.new
  end
  self.class.let :class_under_test do
    Class.new.extend AOP
  end
end
end
