-- q1

data Tree a = Empty | Node (Tree a) a (Tree a)
treesort :: Ord a => [a] -> [a]
treesort xs = tree_inorder (list_to_bst xs)

list_to_bst :: Ord a => [a] -> Tree a
list_to_bst [] = Empty
list_to_bst (x:xs) = bst_insert x (list_to_bst xs)

bst_insert:: Ord a => a -> Tree a -> Tree a
bst_insert i Empty = Node Empty i Empty
bst_insert i (Node l v r)
    | i <= v = (Node (bst_insert i l) v r)
    | i > v = (Node l v (bst_insert i r))

tree_inorder:: Tree a -> [a]
tree_inorder Empty = []
tree_inorder (Node l v r) = tree_inorder l ++ [v] ++ tree_inorder r



-- q2
transpose :: [[a]] -> [[a]]
transpose [] = error "transpose of zero-height matrix"
transpose list@(xs:xss)
  | len > 0   = transpose' len list
  | otherwise = error "transpose of zero-width matrix"
  where len = length xs


transpose' len [] = replicate len []
transpose' len (xs:xss)
  | len == length xs = zipWith (:) xs (transpose' len xss)
  | otherwise = error "transpose of non-rectangular matrix"


zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith _ [] [] = []
zipWith _ [] (_:_) = error "zipWith: list length mismatch"
zipWith _ (_:_) _ = error "zipWith: list length mismatch"
zipWith f (x:xs) (y:ys) = (f x y):(zipWith f xs ys)



-- q3
stats1 ns =
	(length ns,
	 sum ns,
	 sumsq ns
	)

sumsq [] = 0
sumsq (x:xs) = n*n + sumsq ns

stats2 [] = (0,0,0)
stats2 (n:ns) =
	let (l,s,sq) = stats2 ns
	in (l+1, n+s, n*n+sq)
