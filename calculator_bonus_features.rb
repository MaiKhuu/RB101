require 'yaml'
MESSAGES = YAML.load_file("calculator_messages.yml")

LANGUAGE = "viet"

def prompt(message)
  puts("=> #{message}")
end

# default language is English
# change LANGUAGE on top of the program to switch language
def messages(message, lang = "en")
  MESSAGES[lang][message]
end

# this method clean up starting/ trailing zero(s)
def clean_up(num)
  while num.start_with?("0")
    num.delete_prefix!("0")
  end
  
  if num.start_with?(".")
    num.prepend("0")
  end
  
  while num.end_with?("0")
    num.delete_suffix!("0")
  end
  
  if num.end_with?(".") 
    num << "0"
  end
  
  if num.empty? 
    num = "0"
  end
  num
end

# this method check if the number entered is valid
# this will check for both float and integer validations
def valid_number?(num)
  num = clean_up(num)
  
  if num.include?(".")
    num.to_f.to_s == num
  else 
    num.to_i.to_s == num # this makes sure 0 is accepted
  end 
end

def operation_to_message(op)
  case op
  when '1'
    messages("adding", LANGUAGE)
  when '2'
    messages("subtracting", LANGUAGE)
  when "3"
    messages("dividing", LANGUAGE)
  when "4"
    messages("dividing", LANGUAGE)
  end
end

prompt(messages("welcome", LANGUAGE))
name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt(messages("name_error", LANGUAGE))
  else
    break
  end
end

# main loop
loop do
  # input 1st number
  number1 = ''
  loop do
    prompt(messages("first_num_prompt", LANGUAGE))
    number1 = gets.chomp
    if valid_number?(number1)
      break
    else
      prompt(messages("num_error", LANGUAGE))
    end
  end

  # input 2nd number
  number2 = ''
  loop do
    prompt(messages("second_num_prompt", LANGUAGE))
  
    number2 = gets.chomp
    if valid_number?(number2)
      break
    else
      prompt(messages("num_error", LANGUAGE))
    end
  end

  prompt(messages('operator_prompt', LANGUAGE))

  operator = ''
  loop do
    operator = gets.chomp
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(messages("operator_error", LANGUAGE))
    end
  end

  prompt(operation_to_message(operator) + " " + messages("processing", LANGUAGE))

  result = case operator
           when '1'
             number1.to_f + number2.to_f
           when '2'
             number1.to_f - number2.to_f
           when '3'
             number1.to_f * number2.to_f
           when '4'
             number1.to_f / number2.to_f
           end

  prompt(messages("result", LANGUAGE) + " " + result.to_s)

  prompt(messages("restart", LANGUAGE))
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end
