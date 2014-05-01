class ScannerIO
  attr_accessor :io

  def read(*args)
    @io.read(*args)
  end

  def initialize(io)
    if io.is_a? String
      @io = StringIO.new(io)
    else
      @io = io
    end
  end

  def next_byte!
    begin
      @io.read(1).unpack("C").first
    rescue => e
      binding.pry
    end
  end

  def next_long!
    @io.read(4).unpack("L").first
  end

  # move cursor
  def next_string!
    length  = next_long!
    @io.read(length)
  end

  # peek
  def next_ip_address!
    ip4         = next_byte!
    ip3         = next_byte!
    ip2         = next_byte!
    ip1         = next_byte!
    ip_addresss = [ip1, ip2, ip3, ip4].join(".")
  end

  def next_line!
    @io.gets
  end
end
