getNthElem n [] = error "'n' is greater than the length of the list"
getNthElem 1 xs = head xs
getNthElem n xs =
	| n < 1 = error  "'n' is non-positive"
	| otherwise = getNthElem (n-1) (tail xs)
