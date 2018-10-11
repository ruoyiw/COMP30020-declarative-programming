module ManipulateDFA 
where

import DFA
import Data.Char (isDigit, isLower)
import Data.List (sort, nub, intersect, insert, maximum, elemIndex, head, null, maximum, (!!), (\\))
import Data.Maybe

--  THIS FILE CONTAINS MANY COMMENTS LIKE THIS, IN UPPER CASE.
--  THEY ARE INTENDED AS META-COMMENTS, AND THEY SHOULD NOT BE
--  PRESENT IN THE FILE THAT YOU SUBMIT. 

--  IF THERE IS SOME QUESTION THAT YOU DECIDE NOT TO ATTEMPT, LEAVE
--  THAT STUB IN PLACE, WITH A COMMENT THAT SAYS "NOT ATTEMPTED".

--  WE WILL BE RUNNING AUTOMATED TESTING OF WHAT YOU SUBMIT.
--  RATHER THAN SUBMITTING CODE THAT CAUSES A COMPILATION ERROR,
--  LEAVE THE STUB FOR THE OFFENDING FUNCTION IN PLACE; AT LEAST 
--  THAT WILL ALLOW US TO TEST THE OTHER FUNCTIONS YOU HAVE WRITTEN.

--  REPLACE THE FOLLOWING HEADER WITH SOMETHING SUITABLE FOR YOUR
--  OWN SUBMISSION, INCLUDING YOUR NAME AND ANY ACKNOWLEDGEMENTS.

{------------------------------------------------------------------------
   COMP30026 Models of Computation
   Assignment 2, 2016
   Questions 5-9
   Student Name: Ruoyi Wang
   Student Number: 683436
------------------------------------------------------------------------}


--  Keep lists sorted and without duplicates.

tidy :: Ord a => [a] -> [a]
tidy xs
  = nub (sort xs)


--  Calculate the set of reachable states in a given DFA.

reachable :: DFA -> [State]
reachable dfa@(states, alphabet, delta, start_state, accept_states)
  = new
    where
      (old, new) = until stable explore ([], [start_state])
      explore (old_reach, cur_reach) = (cur_reach, expand cur_reach)
      expand reach = tidy (reach ++ successors reach)
      successors reach = [y | ((x,_),y) <- delta, x `elem` reach]
      stable (xs, ys) = xs == ys


--  Calculate the set of generating states in a given DFA.

generating :: DFA -> [State]
generating dfa@(states, alphabet, delta, start_state, accept_states)
  = new
    where
      (old, new) = until stable explore ([], accept_states)
      explore (old_generate, cur_generate) = (cur_generate, expand cur_generate)
      expand generate = tidy (generate ++ successors generate)
      successors generate = [x | ((x,_),y) <- delta, y `elem` generate]
      stable (xs, ys) = xs == ys
      


--  Trim a DFA, that is, keep only reachable, generating states
--  (the start state should always be kept).  

trim :: DFA -> DFA
trim dfa@(states, alphabet, delta, start_state, accept_states)
  = (new_states, alphabet, new_delta, start_state, new_accept_states)
    where 
      new_states = nub (start_state : (reachable dfa `intersect` generating dfa))
      new_delta = [((x,s),y) | ((x,s),y) <- delta, x `elem` new_states, y `elem` new_states]
      new_accept_states = new_states `intersect` accept_states

-------------------------------------------------------------------------

--  Complete a DFA, that is, make all transitions explict.  For a DFA,
--  the transition function is always understood to be total.

complete :: DFA -> DFA
complete dfa@(states, alphabet, delta, start_state, accept_states)
  = (new_states, alphabet, new_delta, start_state, accept_states)
    where 
      -- Make additional delta if there is no transition between each state and each symbol
      delta' = [((x,s),newstate) | x <- states, s <- alphabet, checknull x s delta]
      delta'' = [((newstate,s),newstate) | s <- alphabet]
      -- Not change the delta if the dfa is already complete
      new_delta = if ((length delta) == (length (delta ++ delta'))) 
                  then delta
                  else tidy (delta ++ delta' ++ delta'')
      -- Not change the states if the dfa is already complete
      new_states = if ((length delta) == (length new_delta)) 
                   then states
                   else (tidy states) ++ [newstate]
      -- Create a new state
      newstate = 1 + (maximum states)

-- This function is used for checking if there is an explicit transition between a state and a symbol
-- return true if such transition cannot be fould in the existed transitions
checknull :: Int -> Char -> [Trans] -> Bool
checknull state sym trans = null [((x,s),y) | ((x,s),y) <- trans, x == state, s == sym]
      
       
   
-------------------------------------------------------------------------

--  Systematically replace the names of states in a DFA with 1..n.

normalise :: DFA -> DFA
normalise dfa@(states, alphabet, delta, start_state, accept_states)
  = (new_states, alphabet, new_delta, new_start_state, new_accept_states)
  where 
      new_states = [1..length states]
      -- Find the correspond new_start_state in the new_states list based on its index 
      new_start_state = new_states !! index start_state states
      -- Find the correspond new_accept_states in the new_states list based on their index 
      new_accept_states = [new_states !! index x states | x <- accept_states] 
      -- Get the correspond new_delta
      new_delta = [((new_states !! index x states, s), new_states !! index y states) | ((x,s),y) <- delta]

-- Convert the type Maybe Int to type Int
toInt :: Maybe Int -> Int
toInt (Just x) = x

-- Obtain the index of element x in the list xs
index :: Int -> [Int] -> Int
index x xs = toInt (x `elemIndex` xs)

-------------------------------------------------------------------------

--  To complete and then normalise a DFA:

full :: DFA -> DFA
full 
  = normalise . complete 


--  For a given DFA d, generate a DFA d' so that the languages of d
--  and d' are complementary.

complement :: DFA -> DFA
complement dfa@(states, alphabet, delta, start_state, accept_states)
  = (new_states, alphabet, new_delta, start_state, new_accept_states)
  where 
    full_dfa@(full_states, alphabet, full_delta, start_state, full_accept_states) = full dfa
    new_states = full_states
    new_delta = full_delta
    -- change the non-accept states into accept states in the new DFA
    new_accept_states = full_states \\ full_accept_states


-------------------------------------------------------------------------

--  Given DFAs d1 and d', generate a DFA for the intersection of the
--  languages recognised by d1 and d2.

prod :: DFA -> DFA -> DFA
prod dfa1@(states1, alphabet1, delta1, start_state1, accept_states1) dfa2@(states2, alphabet2, delta2, start_state2, accept_states2)
  = (new_states, alphabet1, new_delta, new_start_state, new_accept_states)         
  where 
    -- To complete and then normalise the two DFAs
    full_dfa1@(fstates1, alphabet1, fdelta1, fstart_state1, faccept_states1) =full dfa1
    full_dfa2@(fstates2, alphabet2, fdelta2, fstart_state2, faccept_states2) =full dfa2
    
    -- Combine the states and delta in each DFA as the temporary states and delta in the new DFA
    temp_states = [(x1, x2) | x1 <- fstates1, x2 <- fstates2]
    temp_delta = [(((x1, x2),s1),(y1, y2)) | ((x1,s1),y1) <- fdelta1, ((x2,s2),y2) <- fdelta2, s1 == s2]
    temp_start_state = (fstart_state1, fstart_state2)
    temp_accept_states = [(a1, a2) | a1 <- faccept_states1, a2 <- faccept_states2]
    
    -- Convert the temporary states and delta into new states and delta in the new DFA
    new_states = [1..length temp_states]
    new_delta = [((toInt (x `elemIndex` temp_states) + 1, s), toInt(y `elemIndex` temp_states) + 1) | ((x,s),y) <- temp_delta]
    new_start_state = toInt (temp_start_state `elemIndex` temp_states) + 1
    new_accept_states = [toInt (x `elemIndex` temp_states) + 1 | x <- temp_accept_states]

-------------------------------------------------------------------------

--  Here is an example (trimmed) DFA; it recognises a*ab*c*

dex :: DFA 
dex 
  = ([0,1,2,3], "abc", t1, 0, [1,2,3])
    where 
      t1 = [ ((0,'a'), 1)
           , ((1,'a'), 1)
           , ((1,'b'), 2)
           , ((1,'c'), 3)
           , ((2,'b'), 2)
           , ((2,'c'), 3)
           , ((3,'c'), 3)
           ]

-------------------------------------------------------------------------
