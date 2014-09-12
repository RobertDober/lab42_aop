require 'ostruct'

module MkConcernHelper
  def mk_concern cls, name
    OpenStruct.new cls: cls, name: name, mthd: cls.instance_method( name )
  end

  def mk_concerns cls, *names
    names.map{ |name| mk_concern cls, name }
  end
end

RSpec.configure do | config |
  config.include MkConcernHelper
end
