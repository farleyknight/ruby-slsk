
module Login
  class Response
    attr_accessor :success, :greeting, :ip_address

    def initialize(scanner)
      @success       = scanner.next_long!  # content.read(4).unpack("L").first
      @greeting      = scanner.next_byte!   # content.read(1).unpack("C").first
      @ip_addresss   = scanner.next_ip_address!
    end
  end
end
