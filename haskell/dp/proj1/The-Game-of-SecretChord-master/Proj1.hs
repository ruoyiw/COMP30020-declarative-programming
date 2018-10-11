--  File        : Proj1.hs
--  Size        : 7 KB
--  Stu_id      : 612840
--  Author      : Yash Narwal
--  Purpose     : Project 1 (Declarative Programming)
--  Modified    : 2015-09-10 18:07:05
--  Uid         : (23373/ ynarwal)
--  Gid         : (3000/ student)

------------------------------------------------------------------------------

{-

  Introduction to the project: The logic of the program is to play two player
  guessing game. one player will select the pitche and other will try to 
  guess it with minimum number of guesses needed to be made following the
  feedback got from previous guess. 
  This game is easy to play but the algorithm behind can be very computational
  demanding for the best average of the guesses.

-}

------------------------------------------------------------------------------


module Proj1 (initialGuess, nextGuess, GameState) where

import Data.List


--I am using this gamestate to keep track of previous filtered list
type GameState = [[[Char]]]
-- compare type is used for better notation and abstraction
data CompareType = Pitche | Note | Octave
                    deriving (Show, Eq, Ord)

------------------------------------------------------------------------------

--Some Constant to define
--getting 2 as an int
indexForGuess :: Int
indexForGuess = 2

--I have run my program with all possible guesses and comes that this 
--first guess gives me best average
getBestFirstGuess :: [String]
getBestFirstGuess = ["A2", "B2", "G3"]

--Layout of the game
getNumList :: [Int]
getNumList = [1,2,3]

getStringList :: [String]
getStringList = ["A","B","C", "D","E", "F", "G"]

noteIndex :: Int
noteIndex = 0 

octaveIndex :: Int
octaveIndex = 1


------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- | Computer the first guess, I find out this guess with runnning 
--all possible options for the first guess and this turns out the best one
initialGuess :: ([String], GameState)
initialGuess = (getBestFirstGuess, getAllOptions)

------------------------------------------------------------------------------


------------------------------------------------------------------------------
{-this function calculate next guess and and a game state 
in game state it returns the possible options left from all of them
Arguemnts:: (first argument list it takes a tuple of list of string which is 
previous guess anda game state , in 2d argument it takes a  tuple of three 
ints which are decided factors of next guess-}
nextGuess :: ([String], GameState) -> (Int, Int, Int) -> ([String], GameState)
nextGuess (target, gameState) (p,n,o) = (myGuess, newGameState)
  where myGuess  = sortedList !! index
        newGameState = filter' gameState target [p,n, o]
        index = quot (length newGameState) indexForGuess
        sortedList = quickSortReverse newGameState
------------------------------------------------------------------------------


------------------------------------------------------------------------------

---this function does reverse sorting on a list
quickSortReverse :: (Ord a) => [a] -> [a]  
quickSortReverse [] = []  
quickSortReverse (x:xs) =   
  let smallerSorted = quickSortReverse [a | a <- xs, a <= x]  
      biggerSorted = quickSortReverse [a | a <- xs, a > x]  
  in  biggerSorted ++ [x] ++ smallerSorted
------------------------------------------------------------------------------


------------------------------------------------------------------------------

--This functions gives all possible options for the targets
getAllOptions =  [ [x,y,z] | x <- combination, y <-combination ,
                 z <- combination , x<y, y < z]
  where nums = getNumList
        strs = getStringList
        combination = [y ++ (show x) | x <- nums, y <- strs]
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--Filter the list down where all remaing elements have same comparsion score
-- with the guess and thus it cut down the list, and we get a list of equal possibilities items.
filter' [] (y:ys) intNumbers = []
filter' (x:xs) list2 intNumbers
  | intNumbers == getScore x list2 = x:(filter' xs list2 intNumbers)
  | otherwise                       = filter' xs list2 intNumbers


------------------------------------------------------------------------------

------------------------------------------------------------------------------

--This function equate if two lists have same value for a note and octave
eqauteNthElementOfList :: Eq a => CompareType -> [a] -> [a] -> Bool
eqauteNthElementOfList compareType l1 l2
  | compareType == Note = (l1 !! noteIndex) == (l2 !! noteIndex)
  | compareType == Octave = (l1 !! octaveIndex) == (l2 !! octaveIndex)

------------------------------------------------------------------------------

------------------------------------------------------------------------------

--we get a tuple of three ints which tell,  how much similarity, 
--these two list of strings are we get three Ints for pitche, 
--note and octave respectively. 
getScoreTuple :: [String] -> [String] -> (Int,Int,Int)
getScoreTuple target guess = (pc, nc, oc)
  where pc =   countCorrect Pitche guess target
        nc =   countCorrect Note guess target
        oc =   countCorrect Octave guess target


--This take the tuple and chuck into a list
getScore :: [String] -> [String] -> [Int]
getScore list1 list2 = [a, b,c]
  where (a,b,c) = getScoreTuple list1 list2
------------------------------------------------------------------------------
  
------------------------------------------------------------------------------
--this functions takes a type to compate and two string's list , 
--it calculate the count for each pitche , note and octave of two given list,
-- which indeed Accordind to spec: number of correct pitche, number of correct 
--note but incorrect octave and last number of crrect octave but incoorect note.
countCorrect :: CompareType -> [String] -> [String] -> Int

countCorrect compareType list1 list2
  | compareType == Pitche = pc
  | compareType == Note = nc
  | compareType == Octave = oc
  where pc = length (getListCommonElement ulist1 list2)
        tc = length ulist1
        nc = tc - ln -pc
        oc = tc - lo -pc
        ulist1 = removeDuplicates list1
        ln = length(deleteFirstsBy(eqauteNthElementOfList Note)ulist1 list2)
        lo = length(deleteFirstsBy(eqauteNthElementOfList Octave)ulist1 list2)

------------------------------------------------------------------------------

------------------------------------------------------------------------------

--It removes the duplicate element from a list
removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates = helper []
    where helper seen1 [] = seen1
          helper seen1 (x:xs)
              | x `elem` seen1 = helper seen1 xs
              | otherwise = helper (seen1 ++ [x]) xs

------------------------------------------------------------------------------

------------------------------------------------------------------------------

--get list of common elements of two lists
getListCommonElement :: Eq t => [t] -> [t] -> [t]


getListCommonElement [] _ = []
getListCommonElement _ [] = []

getListCommonElement list1 list2 = 
  if length list1 >= length list2 then commonElementHelper ulist2 ulist1
  else commonElementHelper ulist1 ulist2
  where ulist2 = removeDuplicates list2
        ulist1 = removeDuplicates list1

commonElementHelper :: Eq t => [t] -> [t] -> [t]

commonElementHelper _ [] = []
commonElementHelper [] _ = []

commonElementHelper (x:xs) list = 
  if x `elem` list then x:commonElementHelper xs list
  else commonElementHelper xs list 
------------------------------------------------------------------------------

-------------------------------End of FIle------------------------------------