class ::Array
  def to_proc
    -> (rcv, *a, &b) {
      rcv.send( *(self + a), &b )
    }
  end
end # class ::Array
