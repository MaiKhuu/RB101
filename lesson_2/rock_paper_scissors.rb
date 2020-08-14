VALID_CHOICES = %w(rock paper scissors)
def prompt(message)
  puts("=> #{message}")
end

def win?(first, second)
  (first == "rock"  && second == "scissors") || (first == "paper" && second == "rock") || (first == "scissors" && second == "paper")
end

# display essage showing who wins
def display_result(player, computer)
  if player == computer 
    prompt("It's a tie!")
  elsif win?(player, computer)
    prompt("You win!")
  else
    prompt("Computer wins!")
  end
end

# main loop
loop do
  # input user choice
  choice= ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = gets.chomp
    
    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("Not valid")
    end
  end
  
  # generate computer choice and compare
  computer_choice = VALID_CHOICES.sample
  prompt("Computer chose: #{computer_choice}")
  display_result(choice, computer_choice)
  
  # ask user if program should restart
  prompt("Do you want to play again? Y to continue")
  answer = gets.chomp
  break unless answer.upcase.start_with?("Y")
end