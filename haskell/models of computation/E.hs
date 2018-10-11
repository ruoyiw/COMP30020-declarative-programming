module E
where

import RunDFA

{------------------------------------------------------------------------
   COMP30026 Models of Computation
   Assignment 2, 2016
   Question 2
   Student Name: Ruoyi Wang
   Student Number: 683436
------------------------------------------------------------------------}

e :: DFA
e
  = ([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15], "abc", t1, 0, [0,1,2,3,5,6,7,8,9,10,11,12,13,14,15])
    where 
      t1 = [ ((0, 'a'), 1)
           , ((0, 'b'), 5)
           , ((0, 'c'), 5)
           , ((1, 'a'), 12)
           , ((1, 'b'), 2)
           , ((1, 'c'), 2)         
           , ((2, 'a'), 13)
           , ((2, 'b'), 3)
           , ((2, 'c'), 3)          
           , ((3, 'a'), 4)
           , ((3, 'b'), 8)
           , ((3, 'c'), 8)           
           , ((4, 'a'), 4)
           , ((4, 'b'), 4)
           , ((4, 'c'), 4)          
           , ((5, 'a'), 6)
           , ((5, 'b'), 14)
           , ((5, 'c'), 14)          
           , ((6, 'a'), 13)
           , ((6, 'b'), 7)
           , ((6, 'c'), 7)           
           , ((7, 'a'), 4)
           , ((7, 'b'), 11)
           , ((7, 'c'), 11)           
           , ((8, 'a'), 9)
           , ((8, 'b'), 4)
           , ((8, 'c'), 4)           
           , ((9, 'a'), 4)
           , ((9, 'b'), 10)
           , ((9, 'c'), 10)           
           , ((10, 'a'), 4)
           , ((10, 'b'), 11)
           , ((10, 'c'), 11)                     
           , ((11, 'a'), 4)
           , ((11, 'b'), 8)
           , ((11, 'c'), 8)           
           , ((12, 'a'), 13)
           , ((12, 'b'), 13)
           , ((12, 'c'), 13)           
           , ((13, 'a'), 4)
           , ((13, 'b'), 4)
           , ((13, 'c'), 4)           
           , ((14, 'a'), 9)
           , ((14, 'b'), 15)
           , ((14, 'c'), 15)
           , ((15, 'a'), 9)
           , ((15, 'b'), 4)
           , ((15, 'c'), 4)
           ]