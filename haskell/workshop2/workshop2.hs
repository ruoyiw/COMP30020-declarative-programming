-- q1

data Suit = clubs | diamonds | hearts | spades
data Rank
= R2 | R3 | R4 | R5 | R6 | R7 | R8 | R9 | R10
| Jack | Queen | King | Ace
data Card = Card Suit Rank


-- q2

data HTML_Font = HTML_Font {
                 fontSize :: Maybe fontSize,
		 fontFace :: Maybe fontFace,
		 fontColor :: Maybe fondColor
		 }

-- or data Fonttag = Fonttag (Maybe Int) (Maybe String) (Maybe fontColor)

type fontSize = Int
type fontFace = String
data fontColor
   = colorName String
   | Hex Int
   | RGB Int Int Int


-- q3

factorial :: Integer -> Integer 
factorial 0 = 1
factorial n = n * factorial (n-1)

factorial n = product [1..n]

-- q4

myElem ::Eq  t=> t -> [t] -> Bool
myElem _ [] = False
myElem a (x:xs) 
     | a == x    = True
     | otherwise = myElem a xs

-- q5

longestPrefix :: Eq t => [t] -> [t] -> [t]
longestPrefix _ [] = []
longestPrefix [] _ = []
longestPrefix (x:xs) (y:ys)
     | x == y = x:(longestPrefix xs ys)
     | otherwise = []

-- q6

maccarthy :: Int -> Int -> Int
maccarthy n 0 = n
maccarthy n 1 
    | n > 100 = maccarthy (n-10)(c-1)
    | otherwise = maccarthy (n+11)(c+1)

mywhile x =
    if cond x then mywhile (next_version_of x)
    else final_version_of x

cond (c,n) = c /= 0
next_version_of (c,n) =
	if n > 100 then (c-1, n-10) else (c+1, n+11)
final_version_of (c,n) = n

mccarthy_91 :: Int -> Int
mccarthy_91 n = mywhile (1, n)

-- q7

range_list min max =
      if min > max then []
      else min : range_list (min+1) max
