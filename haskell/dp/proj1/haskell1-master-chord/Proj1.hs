-- Project 1 Guessing


module Proj1 (initialGuess, nextGuess, GameState) where

    import Data.List
    data GameState = GameState { possibleChords :: [[String]] }
                                

    --initial Guess function
    initialGuess :: ([String],GameState)
    initialGuess = ( firstGuess, (GameState (removeGuess firstGuess allPossibleStates))) 
            where firstGuess = ["A3","G2","D1"]


    nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
    nextGuess (xs_previous, (GameState posChords )) (pitch, note, octave) =
            ( halfGuess, GameState  ( removeGuess halfGuess newPosChords))
        where newPosChords = [x | x<-posChords, ifTarget xs_previous x pitch note octave]
              halfGuess = newPosChords !!( (length newPosChords)`div`2)
              

    --removes a guess from a list of guesses
    removeGuess :: [String] -> [[String]] -> [[String]]
    removeGuess guess [] = []
    removeGuess guess (p:allPos)
        | guess == p = removeGuess guess allPos
        | otherwise = p:removeGuess guess allPos
            
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


    --Returns true if nth elements are equal
    -- You can't recode the wheel
    -- Found in Proj test harness
    eqNth :: Eq a => Int -> [a] -> [a] -> Bool
    eqNth n n1 n2
        | (n1 !! n) == (n2 !! n) = True
        | otherwise = False
   

    --Creates all 1330 possible guesses
    allPossibleStates:: [[String]]
    allPossibleStates = [[a]++[b]++[c] | a<- basicList, b<- basicList, c<- basicList, a/=b, a/=c, b/=c,c<a,b<a,b<c]
                where basicList = [b++a| a<-["1","2","3"], b<-["A","B","C","D","E","F","G"]] 