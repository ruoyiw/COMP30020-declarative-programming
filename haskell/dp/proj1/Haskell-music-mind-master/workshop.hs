-- Transpose a matrix

--transpose:: [[a]] -> [[a]] 
--transpose [] = error "Transpose of empty"
--transpose oMatrix = (head.take) 1 aMatrix,

-- tripleList:: Num a => [a] -> (a,a,a) 
-- tripleList list = ((length list),(sum list),(sum (list^2)))
-- --Just one traversal
-- tripleList list = if firstElement /= []
-- 	                 then (1+ ((fst.tripleList) remainingList),first + ((snd.tripleList) remaingList),first^2 + ((\(_,_,x) -> x) remainingList)^2)  
-- 	                 else 
-- 	
-- 	
-- 	 where firstElement = take 1 list 
-- 	       first        = head firstElement
-- 	       remainingList = init list
	       
fibs:: Int -> [Integer]
fibs 0   = []
fibs 1   = [0]
fibs len = fibs (len -1) ++ [fib len]

--fib:: (Eq a) => a -> a
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib(n-2)	
	
	
	
	
	
	