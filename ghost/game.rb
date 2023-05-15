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
           hash[line.length] << line
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
            @fragment += letter.downcase
        else
            letter = player.alert_invalid_guess
            if valid_play?(letter)
                @fragment += letter.downcase
            else
                puts "You lost your turn, #{@current_player.name}, and have gained a punishment letter!"
                @losses[@current_player] += 1
            end
        end
    end
    def valid_play?(str)
        alpha = ("a".."z").to_a
        if !alpha.include?(str.downcase) || str.length != 1
            return false
        else
            frag = @fragment + str.downcase
            @dictionary[frag.length].each do |word|
                return true if word[0...frag.length] == frag
            end
            return false
        end
    end
    def play_round
        puts "Let's begin a new round!"
        alpha = ("a".."z").to_a
        while alpha.any? {|letter| valid_play?(letter)}
            take_turn(@current_player)
            puts "The string is currently: #{@fragment}"
            next_player!
        end
        puts "This round is over. #{@previous_player.name} has lost the round."
        @fragment = ""
    end
    def run
        while !game_over?
            play_round
            @losses[@previous_player] += 1
            puts "Currently, #{@player_1.name} has #{"GHOST"[0...@losses[@player_1]]} and #{@player_2.name} has #{"GHOST"[0...@losses[@player_2]]}."
        end
        puts "The game is over. #{@previous_player.name} has lost."
    end
    def game_over?
        @losses.has_value?(5)
    end
end