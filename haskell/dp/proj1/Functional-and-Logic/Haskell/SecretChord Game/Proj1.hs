--  File     : Proj1.hs
--  Author   : Liang Han
--  Update   : 23:00 4 Sep 2015
--  Purpose  : Program of Project 1 of COMP90048

module Proj1 (initialGuess, nextGuess, GameState) where

import Data.List
import Data.Function

-- | Used to store the "possbile set" after each guess.
type GameState = [[String]]

-- | Optimal first  guess and also include the whole possible guesses set. 
initialGuess :: ([String],GameState)
initialGuess = (["A1","B1","C2"],chordSet 0 pitchSet)

-- | Invoked by test programm to generate the next guess.
--   First argument is guess last time and the second argument is response
--   last time.
nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
nextGuess lastInput lastResult = 
	let x = (findPossibleSet lastResult (snd lastInput) (fst lastInput)) 
	in ( bestGuess (guessEpSize x x),
	   (findPossibleSet lastResult (snd lastInput) (fst lastInput)))


-- | All possible combinations of "Note" and "Octave".
pitchSet :: [String]
pitchSet = ["A1","A2","A3",
            "B1","B2","B3",
            "C1","C2","C3",
            "D1","D2","D3",
            "E1","E2","E3",
            "F1","F2","F3",
            "G1","G2","G3"]

-- | Generate all possbile chords combined with "Pitches". First argument
--   is start point of the pitch set in the recursion (should be 0). Second
--   argument is pitch set.
chordSet :: Int-> [String] -> [[String]]
chordSet n ps = chordSetHelper n (n+1) (n+2) ps

-- | Helper fucntion to generate guesses. First three arguments that work as
--   pointers to generate a chord with three pitches.
chordSetHelper :: Int->Int->Int->[String]->[[String]]
chordSetHelper p1 p2 p3 ps
	| ((p1<(numPitch-2)) && (p2<(numPitch-1)) && (p3<numPitch)) = 
		[[ps!!p1] ++ [ps!!p2]++[ps!!p3]] ++ chordSetHelper p1 p2 (p3+1) ps
	| ((p1<(numPitch-2)) && (p2<(numPitch-1)) && (p3==numPitch)) = 
		chordSetHelper p1 (p2+1) (p2+2) ps
	| ((p1<(numPitch-2)) && (p2==(numPitch-1))) = 
		chordSetHelper (p1+1) (p1+2) (p1+3) ps
	| otherwise = []
	where numPitch = length pitchSet

-- | All possible responses calculated from chord set. It is used in recursion
--   of other functions. Generating this list is time costy. For limited 
--   test time concern, it is directly stored.
responseSet ::[(Int,Int,Int)]
responseSet = [(3,0,0),(2,0,0),(2,0,1),(1,0,1),(1,0,0),(1,0,2),(0,0,3),(0,0,2),
               (0,0,1),(2,1,0),(1,2,1),(1,2,0),(1,1,1),(1,1,0),(1,1,2),(0,2,1),
               (0,2,2),(0,2,0),(0,1,2),(0,1,1),(0,1,0),(0,1,3),(0,0,0),(1,2,2),
               (0,2,3),(0,3,0),(0,3,2),(0,3,1),(0,3,3)]


-- | Get the best guess with the minimum expected size of left possible set.
bestGuess :: [(Double,[String])]->[String]
bestGuess (x:xs)
	| (fst x == min) = snd x
	| otherwise = bestGuess xs
	where min = minimum (fst (unzip (x:xs)))

-- | Calculate the expected size of next possible set of each chord if guessed 
--   in the possible set.
guessEpSize :: [[String]]->[[String]]->[(Double,[String])]
guessEpSize ps (x:xs) = ((expectedSize 
                          (responseHash responseSet (responseList x ps))),x):
                          guessEpSize ps xs
guessEpSize ps [] = []

-- | Calculate the expected size of left chords by this guess. The argument
--   is the response hash of certain possible set.
expectedSize :: [((Int,Int,Int),Int)]->Double
expectedSize rh = intDivide (sum (map (square) (snd (unzip rh)))) 
				           (sum (snd (unzip rh)))

-- Calculate the division of two Ints and get a Double type result.
intDivide :: Int-> Int ->Double
intDivide a b = (fromIntegral a) / (fromIntegral b)

-- Calculate square of an Int.
square :: Int->Int
square a = a*a

 -- | Get the hash map of how many occurences of each response in the 
 --   response set for the possible data set. The first argument should
 --   be set as the response set. The second argument is 
responseHash :: [(Int,Int,Int)] ->[(Int,Int,Int)] ->[((Int,Int,Int),Int)]
responseHash (x:xs) rl = (x, eleNum x rl) : responseHash xs rl
responseHash [] rl = [] 

-- | Generate response list of one chord with other chords in possible set.
responseList :: [String]->[[String]]->[(Int,Int,Int)]
responseList ch (x:xs) = (response ch x):responseList ch xs
responseList ch [] = []

-- | Find how many times certain response occurs exist in the corresponding
--   response list.
eleNum :: (Int,Int,Int)->[(Int,Int,Int)]->Int
eleNum r rl = length (eleNumHelper r rl)

-- | Helper method of eleNum, generate the list of occurences of ceratin
--   response.
eleNumHelper :: (Int,Int,Int)->[(Int,Int,Int)]->[(Int,Int,Int)]
eleNumHelper response (x:xs)
	| response ==x = x :eleNumHelper response xs
	| otherwise = eleNumHelper response xs
eleNumHelper r [] = []


-- | Find the possible sets which can get the same response from 
--   possible chords which can get the same response from last guess.
findPossibleSet :: (Int,Int,Int)->[[String]]->[String]->[[String]]
findPossibleSet lastresponse (x:xs) lastguess
	| compareResult lastresponse x lastguess = 
		x: findPossibleSet lastresponse xs lastguess
	| otherwise = findPossibleSet lastresponse xs lastguess
findPossibleSet lastresponse [] lastguess = []	

-- | Get the response result by two chords and compare it with the 
--   response from the test program. The match result is Bool type.
compareResult :: (Int,Int,Int)->[String]->[String]->Bool
compareResult rsp c1 c2 = ((response c1 c2) == rsp)


-- | Take in one target and one guess, compare them and return test result.
response :: [String] -> [String] -> (Int,Int,Int)
response target guess = (correctPitch, corretNote, correctOctave)
  where correctPitch = length $ intersect guess target
        leftTarget = deleteList (intersect guess target) target
        leftGuess = deleteList (intersect guess target) guess
        corretNote   = numNoteOct 0 leftTarget leftGuess
        correctOctave = numNoteOct 1 leftTarget leftGuess

-- Delete elements in one list from another list.
deleteList :: [String]->[String]->[String]
deleteList (x:xs) ls = deleteList xs (delete x ls)
deleteList [] ls = ls

-- Get the number of correctNote (n = 0) or correct octave (n = 1).
numNoteOct :: Int -> [String]->[String]->Int
numNoteOct n t g = length $ numNoteOctHelper n t g t g

-- Helper function to get list of the same note or octave.
numNoteOctHelper :: Int->[String]->[String]->[String]->[String]->[String]
numNoteOctHelper n (x:xs) (y:ys) oa ob 
	| ((x!!n)==(y!!n))  = x:numNoteOctHelper n (delete x oa) (delete y ob) 
	                                           (delete x oa) (delete y ob)
	| ((x!!n)/=(y!!n))  = numNoteOctHelper n (x:xs) ys oa ob
numNoteOctHelper n (x:xs) [] oa ob = numNoteOctHelper n xs ob oa ob
numNoteOctHelper n [] _ oa ob = []


