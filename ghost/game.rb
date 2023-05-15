require_relative "player"

class Game
    attr_reader :dictionary
    def initialize(player_1,player_2)
        @player_1 = Player.new(player_1)
        @player_2 = Player.new(player_2)
        @current_player = @player_1
        @previous_player = @player_2
        @fragment = ""
        hash = Hash.new(Array.new(0))
        lines = File.readlines('dictionary.txt').map(&:chomp)
        lines.each do |line|
           arr = []
           (0...line.length).each do |i|
                arr << line[0..i]
            end
           arr.each {|str| hash[str] << line}
        end
        @dictionary = hash
        @losses = Hash.new(0)
    end
    def next_player!
        if @current_player == @player_1
            @current_player = @player_2
            @previous_player = @player_1
        else
            @current_player = @player_1
            @previous_player = @player_2
        end
    end
    def take_turn(player)
        letter = player.guess
        if valid_play?(letter)
            @fragment += letter
        else
            letter = player.alert_invalid_guess
            if valid_play?(letter)
                @fragment += letter
            else
                puts "You lost your turn, #{@current_player.name}, and have gained a punishment letter!"
                @losses[@current_player] += 1
            end
        end
    end
    def valid_play?(str)
        alpha = ("a".."z").to_a
        if !alpha.include?(str) || str.length != 1
            return false
        else
            return @dictionary.has_key?(@fragment + str.downcase)
        end
    end
    def play_round
        puts "Let's begin a new round!"
        while !round_over?
            take_turn(@current_player)
            puts "The string is currently: #{@fragment}"
            next_player!
        end
        if !game_over?
            @losses[@current_player] += 1
            @fragment = ""
            self.play_round
        else
            "The game is over. #{@current_player.name} has lost."
        end
    end
    def round_over?
        alpha = ("a".."z").to_a
        alpha.all? {|char| !@dictionary.has_key?(@fragment + char)}
    end
    def game_over?
        @losses.has_value?(5)
    end
end