append [] lst = lst
append (x:xs) lst = x:append xs lst
