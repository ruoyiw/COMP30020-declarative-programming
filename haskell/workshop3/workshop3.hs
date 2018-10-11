-- q2
ftoc:: Double -> Double
ftoc a = (5/9) * (a − 32)

-- q3
quadRoots :: Double −> Double −> Double −> [Double]
quadRoots a b c 
    | det > 0 = [left - right, left + right]
    | det == 0 = [left]
    | otherwise = []
    where 
      det = b*b - 4*a*c
      left = -b/denom
      right = sqrt det / denom
      denom = 2 * a

-- q4
-- because to sort the list, need to know the order of it, the type should be ord. ord包括大小和等于，Eq只有等于.
merge :: Ord t => [t] -> [t] -> [t]
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys)
    | x < y = x:merge xs (y:ys)
    | otherwise = y:merge (x:xs) ys


-- q5
quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (p:xs) = quicksort lesser ++ [p] ++ quicksort greater
     where 
     lesser = filter (<p) xs
     greater = filter (>=p) xs


-- q6
same_shape :: Tree a b −> Tree c d −> Bool
data Tree k v = Leaf | Node k v (Tree k v) (Tree k v)
                deriving (Eq, Show)
same_shape Leaf Leaf = True
same_shape Leaf (Node _ _ _ _) = False
same_shape (Node _ _ _ _) Leaf = False
same_shape (Node _ _ l1 r1) (Node _ _ l2 r2) = same_shape l1 l2 && same_shape r1 r2


-- q7
data Expression
      = Var Variable
      | Num Integer
      | Plus Expression Expression
      | Minus Expression Expression
      | Times Expression Expression
      | Div Expression Expression
data Variable = A | B
eval :: Integer −> Integer −> Expression −> Integer
eval a b (Var A) = a
eval a b (Var B) = b
eval a b (Num n) = n
eval a b (Plus  e1 e2) = (eval a b e1) + (eval a b e2)
eval a b (Minus e1 e2) = (eval a b e1) - (eval a b e2)
eval a b (Times e1 e2) = (eval a b e1) * (eval a b e2)
eval a b (Div   e1 e2) = (eval a b e1) `div` (eval a b e2)


