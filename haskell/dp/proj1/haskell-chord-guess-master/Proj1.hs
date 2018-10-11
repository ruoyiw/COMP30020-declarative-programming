-- file:    Proj1.hs
-- author:  Franz Neulist Carroll 391929
-- date:    September 2015

module Proj1 (initialGuess, nextGuess, GameState) where

import Proj1Types
import Data.List

-- initialGuess.
initialGuess :: ([String], GameState)
initialGuess = (printGuess initGuess, initState)
    where
        -- Initial guess is A1 B1 A2
        initGuess = readGuess ["A1", "B1", "A2"]
        -- getInitState defined below.
        initState = getInitState

-- nextGuess.
nextGuess :: ([String], GameState) -> Answer -> ([String], GameState)
nextGuess (prevGuess, prevState) answer
    = (printGuess newGuess, newState)
    where
        (newState, newGuess) 
            = oracle prevState (readGuess prevGuess) answer

-- oracle
-- Eliminates guesses incompatible with the answer.
-- Ranks the remaining guesses.
-- Returns the best guess and the remaining guesses.
oracle :: GameState -> Guess -> Answer -> (GameState, Guess)
oracle (GameState possTargs) prevGuess answer
    = ((GameState newTargs), newGuess)
        where
            -- inspector eliminates guesses incompatible with answer.
            newTargs'' = inspector prevGuess answer possTargs
            -- grade the remaining targets, sort them and take the head
            -- as the next guess.
            newTargs' = sort $ grade newTargs'' newTargs''
            (Target rank newGuess) = head newTargs'
            -- Remaining guesses for the new GameState.
            newTargs = safeTail newTargs'

-- inspector
-- TODO: Replace with a fancy filter.
inspector :: Guess -> Answer -> [Target] -> [Target]
inspector _ _ [] = []
inspector prevGuess answer ((Target rank guess):xs)
    -- If the guess is compatible with the answer keep it.
    | compareGuesses prevGuess guess answer
        = (Target rank guess):(inspector prevGuess answer xs) 
    -- Otherwise discard it.
    | otherwise = inspector prevGuess answer xs

-- grade
-- Grades each remaining guess. 
-- For each remaining guess:
--   1. Get a list of all possible answers against
--      all other remaining guesses.
--   2. Calculate via run length encoding of the answer
--      list the maximum number of identical answers.
--      This is the ranking.
-- The lower the ranking the better - the possible identical
-- answers for that guess is lower.
grade :: [Target] -> [Target] -> [Target]
grade _ [] = []
grade possTargs ((Target rank guess):xs)
    = (Target newRank guess):(grade possTargs xs)
        where 
            (newRank, answer)
                -- TODO better than this!
                = head . reverse . sort . encode . sort
                    $ getAnswerLst possTargs guess

-- getAnswerLst
-- Get a list of possible answers for a particular guess against
-- all other possible guesses.
getAnswerLst :: [Target] -> Guess -> [Answer]
getAnswerLst possTargs guess
    = [getAnswer guess possGuess 
        | (Target rank possGuess) <- possTargs]

-- compareGuesses
-- Compare a guess with the previous guess and the answer.
compareGuesses :: Guess -> Guess -> Answer -> Bool
compareGuesses prevGuess guess answer
    = getAnswer prevGuess guess == answer  

-- getAnswer
-- Calculates an answer for two guesses.
getAnswer :: Guess -> Guess -> Answer
getAnswer (Guess ap1 ap2 ap3) (Guess bp1 bp2 bp3)
    = (correct, correctNotes, correctOcts)
        where
            aLst = [ap1, ap2, ap3]
            bLst = [bp1, bp2, bp3]
            -- Correct pitches.
            correctLst = intersect aLst bLst
            correct = length correctLst
            -- The remaining, incorrect pitches.
            aLst' = aLst \\ correctLst 
            bLst' = bLst \\ correctLst
            -- Pass to another function to get lists of
            -- octaves and notes.
            (aOctLst, aNoteLst) = getOctsNotesLsts aLst'
            (bOctLst, bNoteLst) = getOctsNotesLsts bLst'
            -- Pass to another function to get counts of
            -- octaves and notes.
            correctOcts = countOctsNotes bOctLst aOctLst
            correctNotes = countOctsNotes bNoteLst aNoteLst

-- getOctsNotesLsts
-- Takes a list of pitches and returns a tuple of lists
-- of octaves and notes in the pitches without repitition.
getOctsNotesLsts :: [Pitch] -> ([Octave], [Note])
getOctsNotesLsts [] 
    = ([], [])
getOctsNotesLsts ((Pitch o n):xs)
    = (o:a, n:b)
        where
            (a, b) = getOctsNotesLsts xs

-- countOctsNotes
-- Counts the octaves or notes guessed.
countOctsNotes :: (Eq a) => [a] -> [a] -> Int
countOctsNotes [] _ = 0
countOctsNotes _ [] = 0
countOctsNotes (x:xs) ys
    | x `elem` ys   = 1 + countOctsNotes xs (ys \\ [x])
    | otherwise     = countOctsNotes xs ys

-- Misc functions.

-- Run length encoding of a list.
-- Takes a list and forms a list of tuples of 
-- the count of a repeated element and that element.
-- Eg [1,1,2,2,3] -> [(2,1),(2,2),(1,3)]
-- Requires a sorted list as input.
-- Used for ranking procedure.
encode :: (Eq a) => [a] -> [(Int, a)]
encode xs = map (\x -> (length x, head x)) (group xs)

-- safeTail
safeTail []     = []
safeTail (x:[]) = []
safeTail (x:xs) = xs

-- printGuess
-- Turns a Guess into a list of strings.
-- For neatly parsing a guess.
-- Safe? Matches Guess.  
printGuess :: Guess -> [String]
printGuess (Guess (Pitch o1 n1) (Pitch o2 n2) (Pitch o3 n3)) 
    = [(show n1) ++ (tail (show o1)),
    (show n2) ++ (tail (show o2)),
    (show n3) ++ (tail (show o3))]

-- readGuess
-- Turns a list of strings into a Guess.
-- For neatly parsing an answer.
-- Safe? Wildcard pattern match at bottom.
readGuess :: [String] -> Guess
readGuess [[a, b], [c, d], [e, f]] 
    = Guess x y z
        where 
            x = Pitch (read ("O" ++ [b])) (read [a])
            y = Pitch (read ("O" ++ [d])) (read [c])
            z = Pitch (read ("O" ++ [f])) (read [e])
readGuess _
    = error "Error: readGuess - pattern not matched."

-- getInitState.
getInitState :: GameState
getInitState
    = (GameState [(Target 0 (Guess a b c))
        | a <- [minBound::Pitch ..], 
        b <- [a ..], 
        c <- [b ..], 
        a /= b, b /= c,
        -- Prevent the inital guess A1 B1 A2
        (a, b, c) 
            /= ((Pitch O1 A), (Pitch O1 B), (Pitch O2 A))
        ])
