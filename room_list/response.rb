
module RoomList
  class Response
    attr_accessor :rooms

    def initialize(scanner)
      @rooms = []
      n      = scanner.next_long!

      n.times do
        @rooms << scanner.next_string!
      end
    end
  end
end

module PrivilegedUsers
  class Response
    attr_accessor :users

    def initialize(scanner)
      @users = []
      n      = scanner.next_long!

      n.times do
        @users << scanner.next_string!
      end
    end
  end
end
