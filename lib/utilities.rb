require 'date'

# generate a random date between Jan 1, 2014 and now
# maybe it's a good idea to omit keyword arguments
def random_date(start: Date.new(2014, 01, 01).to_time.to_i, finish: Time.now.to_i)
  date = (start..finish)
  Time.at(rand(date))
end

# generate a random string with numbers and letters
def random_string(length=8)
  characters = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9]
  string = ''

  length.times do
    string << characters[rand(0...characters.length)]
  end

  string
end