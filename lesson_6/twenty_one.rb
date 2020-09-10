require "yaml"

MESSAGES = YAML.load_file("twenty_one_messages.yml")
CARDS_NAMES_WITH_VALUES = { "Ace" => 1, "Jack" => 10, "Queen" => 10,
                            "King" => 10, "1" => 1, "2" => 2,
                            "3" => 3, "4" => 4, "5" => 5, "6" => 6,
                            "7" => 7, "8" => 8, "9" => 9 }
STARTING_CARDS_COUNT = 2
BUSTED_VALUE = 21
DEALER_MUST_HIT = 17

def prompt(message)
  puts "=> #{message}"
end

def display_good_bye
  prompt(MESSAGES["bye"])
end

def display_hands(hands)
  system "clear"
  prompt("Dealer has: #{hands['Dealer'][0]} and unknown card")
  prompt("Player has: #{join_and(hands['Player'])}")
end

def display_final_hands_and_points(hands)
  system "clear"
  prompt("Dealer has: #{join_and(hands['Dealer'])}")
  prompt("Player has: #{join_and(hands['Player'])}")
  prompt("Dealer's total: #{calculate_current_values('Dealer', hands)}")
  prompt("Player's total: #{calculate_current_values('Player', hands)}")
end

def join_and(arr)
  return arr[0].to_s if arr.size == 1
  arr[0..-2].join(", ") + " and " + arr[-1].to_s
end

def initialize_new_deck
  deck_hash = {}
  CARDS_NAMES_WITH_VALUES.each { |card, _| deck_hash[card] = 4 }
  deck_hash
end

def random_available_card(cards_hsh)
  cards_hsh.select { |_, amount| amount > 0 }.keys.sample
end

def deal!(player, hand, available)
  hand[player] << random_available_card(available)
  available[hand[player][-1]] -= 1
end

def calculate_current_values(player, hands)
  ace_count = hands[player].count("Ace")
  sum = hands[player].map { |card| CARDS_NAMES_WITH_VALUES[card] }.sum
  ace_count.times { sum += 10 if sum + 10 <= BUSTED_VALUE }
  sum
end

def busted?(player, hands)
  calculate_current_values(player, hands) > BUSTED_VALUE
end

def hit_or_stay(choice)
  hit_choices = ["h", "hit"]
  stay_choices = ["s", "stay"]
  return "hit" if hit_choices.include?(choice.downcase)
  return "stay" if stay_choices.include?(choice.downcase)
  nil
end

def valid_choice?(choice)
  !!hit_or_stay(choice)
end

def player_turn!(hand, whats_left)
  choice = ""
  loop do
    loop do
      prompt(MESSAGES["player_prompt"])
      choice = gets.chomp
      break if valid_choice?(choice)
      prompt(MESSAGES["player_invalid_choice"])
    end

    choice = hit_or_stay(choice)
    deal!("Player", hand, whats_left) if choice == "hit"
    break if choice == "stay" || busted?("Player", hand)
    display_hands(hand)
  end
end

def dealer_turn!(hand, whats_left)
  while calculate_current_values("Dealer", hand) < DEALER_MUST_HIT
    deal!("Dealer", hand, whats_left)
  end
end

def who_wins_this_round(hands)
  winner_id = if busted?("Player", hands)
                "Dealer"
              elsif busted?("Dealer", hands)
                "Player"
              elsif calculate_current_values("Player", hands) >
                    calculate_current_values("Dealer", hands)
                "Player"
              elsif calculate_current_values("Player", hands) <
                    calculate_current_values("Dealer", hands)
                "Dealer"
              end
  winner_id
end

def round_winner?(hands)
  !!who_wins_this_round(hands)
end

def play_again?
  choice = ''
  valid_inputs = ["y", "yes", "n", "no"]
  loop do
    prompt(MESSAGES["play_again"])
    choice = gets.chomp
    break if valid_inputs.include?(choice.downcase)
    prompt(MESSAGES["player_invalid_choice"])
  end
  choice.downcase.start_with?("y")
end

def display_player_blackjack
  prompt("Player's total is #{BUSTED_VALUE}")
  prompt(MESSAGES["player_blackjack"])
end

def display_player_busted(hands)
  display_final_hands_and_points(hands)
  prompt(MESSAGES["player_busted"])
end

def display_dealer_busted(hands)
  display_final_hands_and_points(hands)
  prompt(MESSAGES["dealer_busted"])
end

def display_round_winner(hands)
  display_final_hands_and_points(hands)
  if round_winner?(hands)
    prompt("#{who_wins_this_round(hands)} wins")
  else
    prompt(MESSAGES["tie"])
  end
end

loop do
  available_cards = initialize_new_deck
  current_hands = { "Player" => [], "Dealer" => [] }

  STARTING_CARDS_COUNT.times do
    deal!("Player", current_hands, available_cards)
    deal!("Dealer", current_hands, available_cards)
  end

  display_hands(current_hands)

  if calculate_current_values("Player", current_hands) == BUSTED_VALUE
    display_player_blackjack
  else
    player_turn!(current_hands, available_cards)
    unless busted?("Player", current_hands)
      dealer_turn!(current_hands, available_cards)
    end

    if busted?("Player", current_hands)
      display_player_busted(current_hands)
    elsif busted?("Dealer", current_hands)
      display_dealer_busted(current_hands)
    else
      display_round_winner(current_hands)
    end
  end

  break unless play_again?
end

display_good_bye
