-- q1

maybeApply :: (a −> b) −> Maybe a −> Maybe b
maybeApply f Nothing = Nothing
maybeApply f (Just x) = Just (f x)

-- q2

zWith :: (a −> b −> c) −> [a] −> [b] −> [c]
zWith _ _ [] = []
zWith _ [] _ = []
zWith f (x:xs) (y:ys) = (f x y) : (zWith f xs ys)


-- q3

linearEqn :: Num a => a −> a −> [a] −> [a]
linearEqn _ _ [] = []
linearEqn a b (x:xs) = (a * x + b) : linearEqn a b xs

-- q4

sqrtPM :: (Floating a, Ord a) => a −> [a]
sqrtPM x
    | x > 0 = let y = sqrt x in [y, −y]
    | x == 0 = [0]
    | otherwise = []


allSqrts :: (Floating a, Ord a) => [a] -> [a]
allSqrts [] = []
allSqrts xs = concatMap sqrtPM xs

-- q5

-- (a)
sqrt_pos1 :: (Ord a, Floating a) => [a] -> [a]
sqrt_pos1 xs = map sqrt (filter (>=0) xs)


-- (b)
sqrt_pos2 :: (Ord a, Floating a) => [a] -> [a]
sqrt_pos2 [] = []
sqrt_pos2 (x:xs) =
	if x >= 0 then sqrt x : sqrt_pos2 xs
	else sqrt_pos2 xs


-- (c)


