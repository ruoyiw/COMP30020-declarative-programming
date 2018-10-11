-- q6
complete :: DFA -> DFA
complete dfa@(states, alphabet, delta, start_state, accept_states)
  = (new_states, alphabet, new_delta, start_state, accept_states)
    where 
      delta' = [((x,s),newstate) | x <- states, s <- alphabet, checknull x s]
      delta'' = [((newstate,s),newstate) | s <- alphabet]
      new_delta = (delta ++ delta' ++ delta'')
      new_states = if (null delta') 
                   then states
                   else states ++ [newstate]
      newstate = 1 + maximum states 
      checknull x s = null [((x,s),y) | ((x,s),y) <- delta]
        

-- q8       
complement :: DFA -> DFA
complement dfa@(states, alphabet, delta, start_state, accept_states)
  = (new_states, alphabet, new_delta, new_start_state, new_accept_states)
  where 
    full_dfa@(full_states, alphabet, full_delta, full_start_state, full_accept_states) = full dfa
    new_states = full_states
    new_delta = full_delta
    new_start_state = full_start_state
    new_accept_states = full_states \\ full_accept_states
    
normalise :: DFA -> DFA
normalise dfa@(states, alphabet, delta, start_state, accept_states)
  = (new_states, alphabet, new_delta, new_start_state, new_accept_states)
  where 
      new_states = [1..length states]
      new_start_state = new_states !! index start_state states
      new_accept_states = [new_states !! index x states | x <- accept_states] 
      new_delta = [((new_states !! index x states, s), new_states !! index y states) | ((x,s),y) <- delta]

toInt :: Maybe Int -> Int
toInt (Just x) = x

index :: Int -> [Int] -> Int
index x xs = toInt (x `elemIndex` xs)

-- q9  
prod :: DFA -> DFA -> DFA
prod dfa1@(states1, alphabet1, delta1, start_state1, accept_states1) dfa2@(states2, alphabet2, delta2, start_state2, accept_states2)
  = (new_states, alphabet1, new_delta, new_start_state, new_accept_states)         
  where 
    full_dfa1@(fstates1, alphabet1, fdelta1, fstart_state1, faccept_states1) =full dfa1
    full_dfa2@(fstates2, alphabet2, fdelta2, fstart_state2, faccept_states2) =full dfa2
    temp_states = [(x1, x2) | x1 <- fstates1, x2 <- fstates2]
    temp_delta = [(((x1, x2),s1),(y1, y2)) | ((x1,s1),y1) <- fdelta1, ((x2,s2),y2) <- fdelta2, s1 == s2]
    temp_start_state = (fstart_state1, fstart_state2)
    temp_accept_states = [(a1, a2) | a1 <- faccept_states1, a2 <- faccept_states2]
    new_states = [1..length temp_states]
    temp_delta = 
    