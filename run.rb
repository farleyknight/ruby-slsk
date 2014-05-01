require 'digest/md5'
require 'socket'
require 'yaml'
require 'pry'

require_relative 'scannerio'
require_relative 'login/message'
require_relative 'login/response'
require_relative 'room_list/response'

class ParentMinimumSpeed
  attr_accessor :speed

  def initialize(scanner)
    @speed   = scanner.next_long!
  end
end

class ParentSpeedRatio
  attr_accessor :ratio

  def initialize(scanner)
    @ratio = scanner.next_long!
  end
end

class WishlistInterval
  attr_accessor :interval

  def initialize(scanner)
    @interval = scanner.next_long!
  end
end


class MessageParser
  attr_accessor :io, :scanner

  def initialize(io)
    @io      = io
    @scanner = ScannerIO.new(io)
  end

  def next
    length  = @scanner.next_long!
    scanner = ScannerIO.new(@scanner.read(length))
    type    = scanner.next_long!

    klass = messages[type]
    if klass.nil?
      debug(scanner)
      raise "Cannot handle message type: #{type.inspect}"
    else
      klass.new(scanner)
    end
  end

  def messages
    {
      1   => Login::Response,
      64  => RoomList::Response,
      69  => PrivilegedUsers::Response,
      83  => ParentMinimumSpeed,
      84  => ParentSpeedRatio,
      104 => WishlistInterval
    }
  end

  def debug(scanner)
    while line = scanner.next_line!
      puts line.inspect
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
    s.puts Login::Message.new(username, password, 182).to_message

    puts "Reading response"
    puts "Parsing response"
    parser = MessageParser.new(s)  # from_string(response)

    begin
      loop do
        # parser.debug(ScannerIO.new(s))
        message = parser.next
        puts message.inspect
      end
    rescue => e
      puts "Exception: #{e}"
      puts e.backtrace.join("\n")
    end

    puts "Closing..."
    s.close             # close socket when done
  end
end

thread = Thread.new do
  ServerConnection.new.connect!
end

thread.join
