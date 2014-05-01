require_relative '../packer'

module Login
  class Message
    include Packer

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
  end
end
