class Array
  def to_proc
    -> rcv, *args do
      rcv.send( *(self + args) )
    end
  end
end
