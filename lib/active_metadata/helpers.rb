module  ActiveMetadata::Helpers

  def to_bool str
    return true if str == true || str =~ (/(true|t|yes|y|1)$/i)
    return false if str == false || str.blank? || str =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{str}\"")
  end

end