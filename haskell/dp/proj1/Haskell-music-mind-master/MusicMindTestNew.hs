--  File     : musicmindtest.hs
--  RCS      : $Id$
--  Author   : Peter Schachte
--  Origin   : Sat Aug 20 22:06:04 2011
--  Purpose  : Test program for musicmind project submissions

module Main where

import Data.List
import System.Environment
import System.Exit
import MusicMind
import Debug.Trace

-- | Compute the correct answer to a guess.  First argument is the 
--   target, second is the guess.
response :: [String] -> [String] -> (Int,Int,Int)
response target guess = (right, rightNote, rightOctave)
  where guess'      = nub guess
        right       = length $ intersect guess' target
        num         = length guess'
        rightNote   = num - (length $ deleteFirstsBy (eqNth 0) guess' target) 
                    - right
        rightOctave = num - (length $ deleteFirstsBy (eqNth 1) guess' target) 
                    - right


-- | eqNth n l1 l2 returns True iff element n of l1 is equal to 
--   element n of l2.
eqNth :: Eq a => Int -> [a] -> [a] -> Bool
eqNth n l1 l2 = (l1 !! n) == (l2 !! n)


-- |Returns whether or not the chord passed in is a valid chord.  A
-- chord is valid if it is a list of exactly three valid pitches with 
-- no repeats.
validChord :: [String] -> Bool
validChord chord =
  length chord == 3 && nub chord == chord && all validPitch chord 

    
-- |Returns whether or not its argument is a valid pitch.  That is, it
-- is a two-character strings where the first character is between 'A'
-- and 'G' (upper case) and the second between '1' and '3'.
validPitch :: String -> Bool
validPitch note =
  length note == 2 && 
  note!!0 `elem` ['A'..'G'] && 
  note!!1 `elem` ['1'..'3']


-- | Main program.  Gets the target from the command line (as three
--   separate command line arguments, each a note letter (upper case)
--   followed by an octave number.  Runs the user's initialGuess and
--   nextGuess functions repeatedly until they guess correctly.
--   Counts guesses, and prints a bit of running commentary as it goes.
main :: IO ()
main = do
  args <- getArgs
  let target = args
  let test = head args
  if length args == 3 && validChord target then do
    --let (guess,other) = initialGuess
    --loop target guess other 1
    let combinations = allCombinations ["A","B","C","D","E","F","G"] (1,2,3)
    let average = calculateAverageGuess 0 combinations
    putStrLn $ "You got it in on average: " ++ show average ++ " guesses!"
    else do
    putStrLn "Usage:  musicmind p1 p2 p3"
    putStrLn "   where p1 p2 p3 are 3 different pitches between A1 and G3"
    exitFailure


loop :: [String] -> [String] -> MusicMind.GameState -> Int -> Int --IO ()
loop target guess other guesses =  if answer == (3,0,0)  
	                               then guesses
                                   else loop target guess' other' (guesses+1)
                        where (guess',other') = nextGuess (guess,other) answer 
                              answer = response target guess

calculateAverageGuess:: Int -> [[String]] -> Int
calculateAverageGuess previousNum combinations | trace ("-- Debug:num of guess so far: " ++ show previousNum ++ " target : " ++ (show.head) combinations ++ " remaining targets: " ++ (show.length) combinations) False = undefined
calculateAverageGuess previousNum combinations
	                | length combinations == 1  = (previousNum + (loop (head combinations) guess other 1))
	                | otherwise                 = calculateAverageGuess (previousNum + (loop (head combinations) guess other 1)) (drop 1 combinations)
	            where  (guess,other) = initialGuess 


