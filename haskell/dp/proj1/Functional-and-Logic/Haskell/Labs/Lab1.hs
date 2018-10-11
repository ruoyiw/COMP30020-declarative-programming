module Lab1 (elementPosition, everyNth, elementBefore) where

elementPosition :: Eq t => t -> [t] -> Int
elementPosition elt [] =error "error"
elementPosition elt lst | elt == head lst = 0
	    		| elt /= head lst = 1+elementPosition elt (tail lst)

everyNth ::  Int -> [t] -> [t]
everyNth 0 _ =error "error"
everyNth n lst = if  (null rest)
                 then [] 
                 else head rest : everyNth n (tail rest)
    		 where rest = drop (n-1) lst

elementBefore :: Eq a => a -> [a] -> Maybe a
elementBefore elt [] = Nothing
elementBefore elt lst | tail lst == []         =Nothing
		      | elt == head lst        = Nothing
		      | elt == head (tail lst) = Just (head lst)
		      | elt /= head (tail lst) = elementBefore elt (tail lst)
