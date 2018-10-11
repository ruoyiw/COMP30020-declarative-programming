sum = 0;

file = File.new("result.txt", "r")
lines = []
while (line = file.gets)
  lines << line
end
file.close

lines.each do |line|
  re = /You got it in (\d) guesses!/
  match = line.match re
  unless match.nil?
    guesses = match[1]
    sum = sum + guesses.to_i
  end
end

puts sum / 1330.0

