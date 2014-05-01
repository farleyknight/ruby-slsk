

module RoomList
  class Response
    def initialize(content)
      @count = n = content.read(4).unpack("L").first

      while n > 0
        length = content.read(4).unpack("L").first
        length

        n = n - 1
      end
    end
  end
end
