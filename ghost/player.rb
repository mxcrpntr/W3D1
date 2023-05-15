class Player
    attr_reader :name
    def initialize(name)
        @name = name
    end
    def guess
        print "Enter a new letter: "
        gets.chomp
    end
    def alert_invalid_guess
        print "Sorry, that is not a valid letter, you have one more try to enter a new valid letter: "
        gets.chomp
    end
end