
-- Declarative Programming COMP90048 : Semester 1
-- Project 1 : Secret Chord
-- Author : Ryan O'Kane 
-- Student Number : 587723
module Proj1 (initialGuess, nextGuess, GameState) where

    import Data.List

    -- Stores possible remaining options for the guess
    type GameState = [[String]]

    -- Returns the initial guess and initial GameState with all possible guesses
    initialGuess :: ([String],GameState)
    initialGuess = (initialGuess, initialState) 
        where
            initialGuess = ["A3", "G2", "D1"]
            initialState = removeGuess initialGuess possibleGuesses

    -- Returns the next guess.
    -- Takes in previous guess, GameState and feedback from state and uses it
    -- To decide what to eliminate from possible guesses
    nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState) 
    nextGuess (guess, gameState) feedback = (newGuess, removeGuess newGuess newState) 
        where
            newState = removeIncompatible (guess, gameState) feedback
            newGuess = newState !! ((length newState) `div` 2)
            
    -- Removes any incompatible guesses from the GameState given the feedback
    -- Checks remaining guesses to see if feedback recieved is the same
    -- If feedback is the same then the guess is still a valid answer
    -- Used hint 2 to come up with this method for eliminating guesses
    removeIncompatible :: ([String], GameState) -> (Int,Int,Int) -> GameState
    removeIncompatible (_, []) (_,_,_) = []
    removeIncompatible (guess, x:xs) (p, n, o)
        | p == p' && n == n' && o == o' = x : removeIncompatible (guess, xs) (p, n, o)
        | otherwise                     = removeIncompatible (guess, xs) (p, n, o)
        where (p', n', o') = getFeedback guess x

    -- Function inputs two lists 
    -- Returns the cartesion product of 2 given lists 
    cartProd xs ys = [(x:y) | x <- xs, y <- ys]

    -- Input a single list and an integer
    -- Generates all possible combinations of that list to the size of the int
    sublists _ 0 = [[]]
    sublists [] _ = []
    sublists (x:xs) n = sublists xs n ++ map (x:) (sublists xs $ n - 1)

    -- Returns all guess that are possible in the game
    -- Takes cartesian product of 2 given lists and then maps all possible combinations
    -- Total of 1300 guesses
    possibleGuesses :: [[String]]
    possibleGuesses = sublists (cartProd ['A'..'G'] ["1","2","3"]) 3

    -- Removes a guess from the GameState so you can't pick it again
    removeGuess :: (Eq a) => a -> [a] -> [a]
    removeGuess _ []                    = []
    removeGuess x (y:ys)    | x == y    = removeGuess x ys
                            | otherwise = y: removeGuess x ys

    -- Returns feedback corresponding between a guess and a target
    -- Used to compare the feedback recieved to the feedback from last guess
    -- If both feedbacks are the same, then the potential guess remains valid
    getFeedback :: [String] -> [String] -> (Int,Int,Int)
    getFeedback target guess    = (equalPitch, equalNote, equalOctave)
        where   equalPitch      = correctPitch guess target
                equalNote       = correctNote guess target - equalPitch
                equalOctave     = correctOctave guess target - equalPitch

    -- Returns number of correct pitches between target and guess
    correctPitch :: [String] -> [String] -> Int
    correctPitch [] _       = 0
    correctPitch (x:xs) target
        | x `elem` target   = 1 + correctPitch xs target
        | otherwise         = correctPitch xs target

    -- Returns number of correct notes between target and guess
    -- Minuses the number of correct pitches from final result
    correctNote :: [String] -> [String] -> Int
    correctNote [] _            = 0
    correctNote guess target    = (length guess) - (length $ deleteFirstsBy (compElem 0) guess target)

    -- Returns number of correct octaves between target and guess
    -- Minuses the number of correct pitches from final result
    correctOctave :: [String] -> [String] -> Int
    correctOctave [] _          = 0
    correctOctave guess target  = (length guess) - (length $ deleteFirstsBy (compElem 1) guess target)

    -- Compares a particular element in two lists
    -- True iff element x of list1 is equal to element x of list2
    compElem :: Eq a => Int -> [a] -> [a] -> Bool
    compElem x list1 list2 
        | (list1 !! x) == (list2 !! x)  = True
        | otherwise                     = False



