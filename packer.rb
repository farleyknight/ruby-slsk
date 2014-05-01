
module Packer
  def pack(object, opts = {})
    if object.is_a? Fixnum
      [object].pack("L")
    elsif object.is_a? String
      pack(object.length) + object
    else
      raise "Cannot handle type #{object.class}!"
    end
  end
end
