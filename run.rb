require 'digest/md5'
require 'socket'
require 'yaml'

class LoginMessage
  attr_accessor :username, :password, :version

  def initialize(username, password, version)
    @username = username
    @password = password
    @version  = version
  end

  def to_message
    # hash = Digest::MD5.hexdigest(username + password)
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

class LoginResponse
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

class RoomListResponse
  def initialize(content)
    @count = n = content.read(4).unpack("L").first

    while n > 0
      length = content.read(4).unpack("L").first
      length

      n = n - 1
    end
  end
end

class MessageParser
  attr_accessor :io

  def initialize(io)
    @io = io
  end

  def self.from_string(string)
    MessageParser.new(StringIO.new(string))
  end

  def next
    length  = @io.read(4).unpack("L").first
    content = StringIO.new(@io.read(length))
    type    = content.read(4).unpack("L").first

    if type == 1
      LoginResponse.new(content)
    elsif type == 64
      RoomListResponse.new(content)
    end
  end
end


class ServerConnection
  def initialize
    @config = YAML.load_file("config.yml")
  end

  def username
    @config[:username]
  end

  def password
    @config[:password]
  end

  def host
    "server.slsknet.org"
  end

  def port
    2242
  end

  def connect!
    s = TCPSocket.new(host, port)

    puts "Sending login message"
    s.puts LoginMessage.new(username, password, 182).to_message

    puts "Reading response"
    while line = s.gets
      puts "Reading.."
      puts line.inspect
    end

    puts "Closing"
    s.close             # close socket when done
  end
end

ServerConnection.new.connect!
