-- file:    Proj1Types.hs
-- author:  Franz Neulist Carroll 391929
-- date:    September 2015

module Proj1Types where

-- Type declarations:

-- Octave.
data Octave = O1 | O2 | O3
    deriving (Show, Read, Eq, Ord, Bounded, Enum)

-- Note.
data Note = A | B | C | D | E | F | G
    deriving (Show, Read, Eq, Ord, Bounded, Enum)

-- Pitch.
data Pitch = Pitch Octave Note
    deriving (Show, Read, Eq, Ord)

-- Bounded instance for Pitch.
instance Bounded Pitch where
    minBound = Pitch minBound minBound
    maxBound = Pitch maxBound maxBound

-- Enum instance for Pitch.
instance Enum Pitch where
    fromEnum (Pitch o n) = (fromEnum o) * m + (fromEnum n)
        where
            m = 1 + (fromEnum (maxBound::Note))
    toEnum x = (Pitch o n)
        where
            m = 1 + (fromEnum (maxBound::Note))
            o = toEnum(x `div` m)
            n = toEnum(x `mod` m)
    enumFrom x  = enumFromTo x maxBound
    enumFromThen x y = enumFromThenTo x y bound
        where
            bound 
                | fromEnum y >= fromEnum x = maxBound
                | otherwise = minBound

-- Guess.
data Guess = Guess Pitch Pitch Pitch
    deriving (Show, Eq, Ord)

-- Possible Targets.
-- Int is for ranking guesses for choosing the next guess. 
data Target = Target Int Guess 
    deriving (Show, Eq, Ord)

-- Game State.
data GameState = GameState [Target]
    deriving Show

-- Answer.
type Answer = (Int, Int, Int)
