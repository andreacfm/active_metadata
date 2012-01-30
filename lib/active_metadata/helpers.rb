module  ActiveMetadata::Helpers

  def to_bool str
    return true if str == true || str =~ (/(true|t|yes|y|1)$/i)
    return false if str == false || str.blank? || str =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{str}\"")
  end

end

class String
  # transform a symbol/string into a class
  def to_class
    self.to_s.camelize.constantize
  end
end

class Symbol
  # transform a symbol/string into a class
  def to_class
    self.to_s.to_class
  end
end
