--  File       : Proj1.hs
--  Author     : Ruoyi Wang
--  Student No.: 683436
--  Update     : 20:00 24 Aug 2017
--  Purpose    : Declarative Programming COMP30020 Project 1


-- This code implements a game of ChordProbe. One player will be the composer and the other is 
-- the performer. The composer begins by selecting a three-pitch musical chord, 
-- where each pitch comprises a musical note, one of A, B, C, D, E, F, or G, and an octave, 
-- one of 1, 2, or 3. This chord will be the target for the game. 
-- Then the performer repeatedly chooses a similarly defined chord as a guess 
-- and tells it to the composer, who responds by giving the performer the feedback
-- including correct pitches, correct notes and correct octaves. 
-- The game finishes once the performer guesses the correct chord (all three pitches in the
-- guess are in the target). The object of the game for the performer is to find the target with
-- the fewest possible guesses.



module Proj1 (initialGuess, nextGuess, GameState) where
import Data.List


-- Stores remaining list of possible targets that are consitent with the answers. 
type GameState = [[String]]


-- A musical note, one of A, B, C, D, E, F, or G
note :: [String]
note = ["A","B","C","D","E","F","G"]


-- An octave, one of 1, 2, or 3
octave :: [String]
octave = ["1","2","3"]


-- A chord is represented as a list of two-character strings, where the first
-- character is an upper case letter between ’A’ and ’G’ representing the note, 
-- and the second is a digit character between ’1’ and ’3’ representing the octave.
chord :: [String]
chord = [x ++ y | x <- note, y <- octave]


-- Takes no input arguments, and returns a pair of an initial guess and a game state
-- which is the set of all possible target  without the initial guess.
initialGuess :: ([String], GameState)
initialGuess = (initialGuess, removeGuess initialGuess possibleTargets)
    where initialGuess = ["A1","B1","C2"]


-- Takes as input a pair of the previous guess and game state, and the feedback to this
-- guess as a triple of correct pitches, notes, and octaves, and returns a pair of
-- the next guess and game state
nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
nextGuess (preGuess, gameState) answer = (newGuess, removeGuess newGuess newState) 
    where newState = filterConsistentAnswer (preGuess, gameState) answer
          newGuess = bestGuess (guessRemainingNum newState newState)
          

-- Filters guesses that are consistent with the answers you have received 
-- for previous guesses.
filterConsistentAnswer :: ([String], GameState) -> (Int,Int,Int) -> GameState
filterConsistentAnswer (_, []) _ = []
filterConsistentAnswer (preGuess, guess:guessList) answer
    | answer == answer' 
                = guess : filterConsistentAnswer (preGuess, guessList) answer
    | otherwise = filterConsistentAnswer (preGuess, guessList) answer
    where answer' = getAnswer preGuess guess



-- Selects a guess that gives the minimum expected number of remaining candidates
bestGuess :: [([String], Double)] -> [String]
bestGuess [] = []
bestGuess (x:xs)
    | snd x == minRemaining   = fst x
    | otherwise               = bestGuess xs
    where minRemaining        = minimum (snd (unzip (x:xs)))


-- Calculates the average remaining targets expected for an answer
avgRemainingTargets :: [Int] -> Double
avgRemainingTargets answerList = (fromIntegral (sumSquare answerList)) 
                                 / (fromIntegral (sum answerList))



-- Calculates the expected number of remaining candidates for each guess in the possible target set
guessRemainingNum :: GameState -> GameState -> [([String], Double)]
guessRemainingNum [] _     = []
guessRemainingNum (x:xs) ys = (x, avgRemainingTargets distinctAnswer) 
                               : guessRemainingNum xs ys
    where answerSet      = getAnswerSet x ys
          answerSet'     = nub answerSet
          distinctAnswer = countDistinctAnswer answerSet' answerSet
   
                  

-- Returns the set of answers between one guess with other guesses in the possible target set
getAnswerSet :: [String] -> GameState -> [(Int,Int,Int)]
getAnswerSet _ []                = []
getAnswerSet guess (x:guessList) = (getAnswer guess x) : getAnswerSet guess guessList



-- Collects all the distinct answers for a given guess and for each answer, 
-- counting the number of targets that would give that answer. 
countDistinctAnswer :: [(Int,Int,Int)] -> [(Int,Int,Int)] -> [Int]
countDistinctAnswer [] _      = []
countDistinctAnswer (x:xs) ls = (numOccurrence x ls) : countDistinctAnswer xs ls



-- Calculates how many times an element occurs in a list.
numOccurrence :: (Int,Int,Int) -> [(Int,Int,Int)] -> Int
numOccurrence x xs = length (filter (==x) xs)
  


-- All possible combination of pitches, there are 1330 possible targets.
possibleTargets :: [[String]]
possibleTargets = [[x,y,z] | x <- chord, y <- chord, z <- chord,
                  x/=y, y/=z, x/=z, x < y, y < z] 


-- Removes a guess from the GameState so you can't pick it again
removeGuess :: (Eq a) => a -> [a] -> [a]
removeGuess _ [] = []
removeGuess x (y:ys)   
    | x == y    = removeGuess x ys
    | otherwise = y:removeGuess x ys



-- Returns the number of correct pitches, notes and octaves to a guess.  
-- First argument is the target, second is the guess.
getAnswer :: [String] -> [String] -> (Int,Int,Int)
getAnswer target guess = (correctPitch, correctNote, correctOctave)
    where correctPitch  = length $ intersect guess target
          correctNote   = length guess - (length $ deleteFirstsBy (eqNth note) guess target)
                        - correctPitch
          correctOctave = length guess - (length $ deleteFirstsBy (eqNth octave) guess target) 
                        - correctPitch
          note = 0
          octave = 1

 

-- Returns True iff element n of l1 is equal to element n of l2.
eqNth :: Eq a => Int -> [a] -> [a] -> Bool
eqNth n l1 l2 = (l1 !! n) == (l2 !! n)


-- Calculate the sum of square of the numbers.
sumSquare :: [Int] -> Int
sumSquare [] = 0
sumSquare (n:ns) = n * n + sumSquare ns



