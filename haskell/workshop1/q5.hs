xor1 False False = False
xor1 False True  = True
xor1 True  False = True
xor1 True  True  = False

xor2 x y = (x || y) && not (x && y)
