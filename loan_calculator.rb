require 'yaml'
MESSAGES = YAML.load_file("loan_messages.yml")

# prompts formatting
def prompt(message)
  puts "=> #{message}"
end

#clean up input string representing a number or percentage
def clean_up(num)
  
  while num.start_with?("0")
    num.delete_prefix!("0")
  end
  
  if num.start_with?(".")
    num.prepend("0")
  end
  
  if num.include?(".")
    while num.end_with?("0")
      num.delete_suffix!("0")
    end
    
    if num.end_with?(".")
      num << "0"
    end
  end
  
  num
end

# check if the number entered is a valid number
def valid_number?(num)
  if num.empty? 
    return false
  end
  
  if num.include?(".")
    num.to_f.to_s == num
  else
    num.to_i.to_s == num
  end
end

# determine if the selection is month or year
def month_or_year(selection)
  case selection
  when "Y"
    "YEARS"
  when "M"
    "MONTHS"
  end
end

# calculate monthly payment given amount, interest rates, duration
def calculate(amt, int, dur)
  amt = amt.to_f
  int = int.to_f
  dur = dur.to_f
  amt * (int / (1 - ((1 + int) ** (-dur))))
end

# main loop
loop do
  prompt(MESSAGES["welcome"])
  
  # input and validate amount in dollars
  amount = ''
  loop do
    prompt(MESSAGES["amount"])
    amount = clean_up(gets.chomp)
    if valid_number?(amount)
      break
    else 
      prompt(MESSAGES["amount_error"])
    end
  end
  
  # input, validate, and standardize interest rate in months
  apr = ''
  loop do
    prompt(MESSAGES["interest"])
    apr = clean_up(gets.chomp)
    if valid_number?(apr)
      break
    else
      prompt(MESSAGES["interest_error"])
    end
  end
  monthly_interest = apr.to_f / 1200
  
  # input and validate loan duration selection
  selection = ''
  loop do
    prompt(MESSAGES["duration_selection"])
    selection = gets.chomp.upcase! 
    if %w(Y M).include?(selection)
      break
    else
      prompt(MESSAGES["selection_error"])
    end
  end
  
  # input duration
  duration = ''
  loop do
    prompt(MESSAGES["duration"] + month_or_year(selection))
    duration = clean_up(gets.chomp)
    if valid_number?(duration)
      break
    else
      prompt(MESSAGES["duration_error"])
    end
  end
  
  # standardize duration input to monthly
  if selection == 'Y'
    monthly_duration = duration.to_f * 12
  else 
    monthly_duration = duration.to_f
  end
  
  # calculate and display result
  monthly_payment = calculate(amount, monthly_interest, monthly_duration)
  prompt(MESSAGES["result"] + (monthly_payment.round(2).to_s))
  
  # restart calculator prompt
  prompt(MESSAGES["restart"])
  restart = gets.chomp
  if !(restart.upcase.start_with?("Y"))
    break
  end
end