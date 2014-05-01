require 'digest/md5'
require 'socket'
require 'yaml'

require_relative 'login/message'
require_relative 'login/response'
require_relative 'room_list/response'


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
      Login::Response.new(content)
    elsif type == 64
      RoomList::Response.new(content)
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
    while line = s.gets
      puts "Reading.."
      puts line.inspect
    end

    puts "Closing"
    s.close             # close socket when done
  end
end

ServerConnection.new.connect!
