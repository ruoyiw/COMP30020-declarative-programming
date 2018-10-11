module Lab1 (subst, interleave, unroll) 
where

{------------------------------------------------------------------------
    Declarative Programming COMP30020 Assignment 1
    Student name: Ruoyi Wang
    Student No.: 683436
------------------------------------------------------------------------}

-- Q1

subst :: Eq t => t -> t -> [t] -> [t]
subst _ _ [] = []
subst a b (x:xs) 
    | a == x    = b:subst a b xs
    | otherwise = x:subst a b xs


-- Q2

interleave :: [t] -> [t] -> [t]
interleave [] [] = []
interleave xs [] = xs
interleave [] ys = ys
interleave (x:xs) (y:ys) = x:y:interleave xs ys


-- Q3

unroll :: Int -> [a] -> [a]
unroll a [] = []
unroll 0 xs = []
unroll a (x:xs)  
    | a < 0          = error "'a' is negative"
    | a > length (x:xs) = (x:xs) ++ unroll (a - length (x:xs)) (x:xs)
    | otherwise = x:unroll (a-1) xs
