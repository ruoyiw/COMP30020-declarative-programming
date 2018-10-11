k :: Integer -> Integer -> Integer
k n m                                         -- find K^n_m (n over m)
  = numerator `div` denominator
    where
      numerator   = product [n-m+1..n]
      denominator = product [1..m]
