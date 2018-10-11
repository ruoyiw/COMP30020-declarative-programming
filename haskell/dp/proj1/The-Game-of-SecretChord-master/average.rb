def count_average
  contents = File.read("result4.txt")
  arr = contents.split(/\n/)

  arr.each do |line|
    intergers = line.split(',')
    total = 0
    intergers.each {|x| total += x.to_f}
    str = (total/intergers.size).to_s + "\n"
    File.write("result5.txt",str, :mode => 'a')
  end
  #total = 0
  #arr.each {|x| total += x.to_f}
  puts arr.size
  #puts total/arr.size
end



def calculate_best
  contents = File.read("result5.txt")
  arr = contents.split(/\n/)
  smallest = 10
  i = 0
  arr.each do |x|
    if(x.to_f < smallest)
      smallest = x.to_f
    end

  end
  puts smallest.to_s + " " + arr.index(smallest.to_s).to_s
  #puts total/arr.size

end
#count_average
#calculate_best



def count_average_for_one_loop
  contents = File.read("result.txt")
  arr = contents.split(/,/) 
  total = 0
  arr.each {|x| total += x.to_f}
  #puts arr.size
  puts total/arr.size
  puts arr.size
end
count_average_for_one_loop