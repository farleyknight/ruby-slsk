
module Login
  class Response
    attr_accessor :ip_address

    def initialize(content)
      @success       = content.read(4).unpack("L").first
      @greet_length  = content.read(1).unpack("C").first

      ip4            = content.read(1).unpack("C").first
      ip3            = content.read(1).unpack("C").first
      ip2            = content.read(1).unpack("C").first
      ip1            = content.read(1).unpack("C").first

      @ip_addresss   = [ip1, ip2, ip3, ip4].join(".")
    end
  end
end
