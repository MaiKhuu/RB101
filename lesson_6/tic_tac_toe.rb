require 'yaml'

MESSAGES = YAML.load_file("tic_tac_toe_messages.yml")
INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
FIRST_MOVE = "choose".capitalize
CENTER_BOARD = 5
WINNING_COMBOS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                 [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                 [[1, 5, 9], [3, 5, 7]]
WINNING_STREAK = 5

def prompt(message)
  puts "=> #{message}"
end

def joinor(arr, punc = ", ", word = "or")
  return arr[0].to_s if arr.size == 1
  arr[0..-2].join(punc) + punc + word + " " + arr[-1].to_s
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system "clear"
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |     "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |     "
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |i| new_board[i] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def valid_choice?(brd, choice)
  return false if choice != choice.to_i.to_s
  empty_squares(brd).include?(choice.to_i)
end

def player_turn!(brd)
  choice = ""
  prompt("Player's turn. Chose a square: #{joinor(empty_squares(brd))}")

  loop do
    choice = gets.chomp
    break if valid_choice?(brd, choice)
    prompt(MESSAGES["invalid_move"])
  end

  brd[choice.to_i] = PLAYER_MARKER
end

# rubocop:disable Layout/LineLength
def defensive_move(brd)
  WINNING_COMBOS.each do |combo_array|
    if combo_array.count { |position| brd[position] == PLAYER_MARKER } == 2 &&
       combo_array.count { |position| brd[position] == INITIAL_MARKER } == 1
      return combo_array[combo_array.index { |position| brd[position] == INITIAL_MARKER }]
    end
  end
  nil
end

def winning_move(brd)
  WINNING_COMBOS.each do |combo_array|
    if combo_array.count { |position| brd[position] == COMPUTER_MARKER } == 2 &&
       combo_array.count { |position| brd[position] == INITIAL_MARKER } == 1
      return combo_array[combo_array.index { |position| brd[position] == INITIAL_MARKER }]
    end
  end
  nil
end
# rubocop:enable Layout/LineLength

def possible_win?(brd)
  !!winning_move(brd)
end

def need_to_defend?(brd)
  !!defensive_move(brd)
end

def computer_turn!(brd)
  choice = if possible_win?(brd)
             winning_move(brd)
           elsif need_to_defend?(brd)
             defensive_move(brd)
           elsif brd[CENTER_BOARD] == INITIAL_MARKER
             CENTER_BOARD
           else
             empty_squares(brd).sample
           end
  brd[choice] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty? ? true : false
end

def detect_winner(brd)
  WINNING_COMBOS.each do |line|
    if line.all? { |idx| brd[idx] == PLAYER_MARKER }
      return "Player"
    elsif line.all? { |idx| brd[idx] == COMPUTER_MARKER }
      return "Computer"
    end
  end
  nil
end

def someone_win?(brd)
  !!detect_winner(brd)
end

def update_scores!(sc, winner)
  sc[winner] += 1 unless winner.nil?
end

def display_score(hsh)
  hsh.each { |player, score| prompt("#{player}'s current score is #{score}") }
end

def who_wins_overall(hsh)
  hsh.each { |player, score| return player if score == WINNING_STREAK }
  nil
end

def overall_winner?(hsh)
  !!who_wins_overall(hsh)
end

def starting_player
  if FIRST_MOVE == "Choose"
    prompt(MESSAGES["first_move_selection"])
    choice = gets.chomp.downcase
    choice.start_with?("y") ? "Player" : "Computer"
  else
    FIRST_MOVE
  end
end

def switch_player(player)
  player == "Player" ? "Computer" : "Player"
end

def place_piece!(brd, player)
  player == "Player" ? player_turn!(brd) : computer_turn!(brd)
end

score_board = { "Player" => 0, "Computer" => 0 }
system "clear"
current_player = starting_player

loop do
  board = initialize_board

  loop do
    display_board(board)
    place_piece!(board, current_player)
    break if someone_win?(board) || board_full?(board)
    current_player = switch_player(current_player)
  end

  display_board(board)
  if someone_win?(board)
    prompt("#{detect_winner(board)} won!")
  else
    prompt("It's a tie!")
  end

  update_scores!(score_board, detect_winner(board))
  display_score(score_board)
  break if overall_winner?(score_board)

  prompt(MESSAGES["play_again?"])
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

# rubocop:disable Layout/LineLength
if overall_winner?(score_board)
  prompt("#{who_wins_overall(score_board)} won the game by reaching #{WINNING_STREAK} wins!")
end
# rubocop:enable Layout/LineLength

prompt(MESSAGES["game_ended"])
