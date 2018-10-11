import Control.Monad

import Data.List
import System.Environment
import System.Exit
import Proj1

allPossibleStates = [[a]++[b]++[c] | a<- basicList, b<- basicList, c<- basicList, a/=b, a/=c, b/=c,c<a,b<a,b<c]--[ x | x<-(replicateM 3 [b++a | a<- ["1"], b<-["A","B","C"]]), validChord x]
                where basicList = [b++a| a<-["1","2","3"], b<-["A","B","C","D","E","F","G"]]


--rate all guesses takes in all guesses and returns the guess with the max??
bestGuess :: [[String]] -> [String] -> Int ->Int->Int->Int-> [String]
bestGuess [] previousG maxG _ _ _= previousG 
bestGuess (g:guesses) previousG maxG pitch note octave
    | (newI > maxG) = bestGuess guesses g newI pitch note octave
    | otherwise =  bestGuess guesses previousG maxG pitch note octave
    where newI = rateGuess g guesses pitch note octave


--takes in a guess & all possible states and returns the amount of branches it would cull
-- the higher the score the better
rateGuess :: [String] -> [[String]] -> Int ->Int->Int -> Int
rateGuess pretendTarget [] _ _ _= 0
rateGuess pretendTarget (p:possible) pitch note octave
    | ifTarget pretendTarget p pitch note octave = 1 + rateGuess pretendTarget possible pitch note octave
    | otherwise = 0+rateGuess pretendTarget possible pitch note octave

--if target takes in previous guess and potentional guess and produces
    -- the pitch, note & octave results
ifTarget :: [String] -> [String] -> Int->Int->Int -> Bool
ifTarget xs_previous possible pitch note octave
    | (pitchComparison xs_previous possible == pitch) && (noteComparison xs_previous possible == note) 
        && (octaveComparison xs_previous possible == octave) = True
    | otherwise = False

    -- a function which takes in previous guess and target and returns its pitch hint
pitchComparison :: [String] -> [String] -> Int
pitchComparison [] _ = 0
pitchComparison (p:previous) target 
    | p `elem` target = 1 + pitchComparison previous target
    |otherwise = pitchComparison previous target

--function takes in two guesses and returns the note hint
noteComparison  :: [String] -> [String] -> Int
noteComparison [] _ = 0
noteComparison previous target = (length previous) 
            - (length $ deleteFirstsBy (eqNth 0) previous target) - pitchComparison previous target

--function that takes in guess & target and returns octave hint
octaveComparison  :: [String] -> [String] -> Int
octaveComparison [] _ = 0
octaveComparison previous target = (length previous) 
            - (length $ deleteFirstsBy (eqNth 1) previous target) - pitchComparison previous target


-- | eqNth n l1 l2 returns True iff element n of l1 is equal to 
--   element n of l2.
eqNth :: Eq a => Int -> [a] -> [a] -> Bool
eqNth n l1 l2 = (l1 !! n) == (l2 !! n)



--remove all guesses that does not have at least one of these pitches
--Take in previous guess and filter down possibilities
removeGuesses :: [String] -> [[String]] -> [[String]]
removeGuesses [] _ = []
removeGuesses _ [] = []
removeGuesses xs (y:ys)
    | pitchsInGuess xs y = y: removeGuesses xs ys
    | otherwise = removeGuesses xs ys


--remove all occurences of a Note from the possibilities
removeNote :: String -> [[String]] -> [[String]]
removeNote note [] = []
removeNote note (x:xs)
    | noteInGuess note x = removeNote note xs
    | otherwise = x:removeNote note xs


-- is the Note in the guess
noteInGuess :: String -> [String] -> Bool
noteInGuess note [] = False
noteInGuess note (x:xs) = if note == ([x !! 0]) then True else noteInGuess note xs

-- Are any of the pitches in the
pitchsInGuess :: [String] -> [String] -> Bool
pitchsInGuess [] _ = False
pitchsInGuess (p:pitches) guess 
    | p `elem` guess = True
    | otherwise = pitchsInGuess pitches guess



-- makes sure there is no pitch that is the same
validChord :: [String] -> Bool
validChord [] = True
validChord (x:xs)
    | x `elem` xs = False
    | otherwise = validChord xs


-- remove all occurences of an element from list
remove :: (Ord a) => a ->[a] -> [a]
remove _ [] = []
remove a (x:xs)
    | a == x = remove a xs
    | otherwise = x : remove a xs