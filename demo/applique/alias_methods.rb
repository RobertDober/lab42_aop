class ::Module
  def alias_methods *aliases
    from = aliases.pop.fetch :from
    aliases.each do | alia |
      alias_method alia.to_sym, from.to_sym
    end
  end
end # class Module
