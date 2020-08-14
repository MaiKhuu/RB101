VALID_CHOICES = %w(rock paper scissors spock lizard)
WINNING_STREAK = 5

def prompt(message)
  puts("=> #{message}")
end

def win?(first, second)
  (first == "rock" && (second == "scissors" || second == "lizard")) ||
  (first == "paper" && (second == "rock" || second == "spock")) ||
  (first == "scissors" && (second == "paper" || second == "lizard")) ||
  (first == "lizard" && (second == "paper" || second == "spock")) ||
  (first == "spock" && (second == "scissors" || second == "rock"))
end

# input valid if starting with R, P, S, L
def legal_choices(input)
  if input.empty?
    return false
  else
    (VALID_CHOICES.map { |c| c[0] }).include?(input[0].downcase)
  end
end

# prompt user to choose between scissors or spock
def scissors_or_spock(input)
  if input[0..1].upcase == "SP"
    return "spock"
  elsif input[0..1].upcase == "SC"
    return "scissors"
  end

  prompt("Do you mean SCISSORS or SPOCK?")
  choice = gets.chomp
  scissors_or_spock(choice)
end

# change user input to standardized full word
def standardized_choice(input)
  if input.upcase.start_with?("R")
    "rock"
  elsif input.upcase.start_with?("P")
    "paper"
  elsif input.upcase.start_with?("L")
    "lizard"
  elsif input.upcase == "SPOCK"
    "spock"
  elsif input.upcase == "SCISSORS"
    "scissors"
  else
    scissors_or_spock(input)
  end
end

# ask for valid user input
def user_input
  choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = gets.chomp

    if legal_choices(choice)
      choice = standardized_choice(choice)
      break
    else
      prompt("Not Valid")
    end
  end
  choice
end

# Final result annoucement
def display_match_result(player_choice, computer_choice)
  if win?(player_choice, computer_choice)
    prompt("You win this round.")
  elsif win?(computer_choice, player_choice)
    prompt("Computer wins this round")
  else
    prompt("It's a tie.")
  end
end

# current result announcement
def display_current_result(player_score, computer_score)
  prompt("You current score: #{player_score}")
  prompt("Computer current score: #{computer_score}")
end

# display message showing who wins
def display_final_result(player)
  if player == WINNING_STREAK
    prompt("\nYou win overall!")
  else
    prompt("\nComputer wins overall")
  end
end

# what score user gets
def update_amount(boolean)
  if boolean
    1
  else
    0
  end
end

# restart the game or not
def play_again?
  prompt("Do you want to play again? say YES if so")
  input = ''
  loop do
    input = gets.chomp
    if input.empty?
      prompt("Not a valid response")
    else
      break
    end
  end

  if input.downcase.start_with?("y")
    true
  else
    false
  end
end

prompt("Welcome to Rock Paper Scissors Lizard Spock")

# main loop
loop do
  # scores priming
  user_score = 0
  computer_score = 0
  prompt("\n")
  display_current_result(user_score, computer_score)

  # game loop
  while !(user_score == WINNING_STREAK || computer_score == WINNING_STREAK)
    # input user choice
    prompt("\n")
    user_choice = user_input

    # generate computer's choice, compute result, output
    computer_choice = VALID_CHOICES.sample
    prompt("You chose: #{user_choice}, and Computer chose: #{computer_choice}")
    display_match_result(user_choice, computer_choice)

    # update total scores
    user_score += update_amount(win?(user_choice, computer_choice))
    computer_score += update_amount(win?(computer_choice, user_choice))

    display_current_result(user_score, computer_score)
  end

  display_final_result(user_score)
  break unless play_again?
end

prompt("Thanks for playing.")
