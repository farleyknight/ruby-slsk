
module Login
  class Message
    attr_accessor :username, :password, :version

    def initialize(username, password, version)
      @username = username
      @password = password
      @version  = version
    end

    def to_message
      message_length + content
    end

    def message_type
      1
    end

    def message_length
      pack(content.length)
    end

    def content
      pack(message_type) +
        pack(username) +
        pack(password) +
        pack(version)
    end

    def pack(object)
      if object.is_a? Fixnum
        [object].pack("L")
      elsif object.is_a? String
        # object + pack(object.length)
        pack(object.length) + object
      else
        raise "Cannot handle type #{object.class}!"
      end
    end
  end
end
