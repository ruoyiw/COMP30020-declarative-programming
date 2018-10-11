module T
where

import RunTM

{------------------------------------------------------------------------
   COMP30026 Models of Computation
   Assignment 2, 2016
   Question 3
   Student Name: Ruoyi Wang
   Student Number: 683436
------------------------------------------------------------------------}

t :: TM
t 
  = [ ((1,' '), (2,' ',R))
    , ((2,'a'), (3,'x',R))
    , ((2,'b'), (6,'y',R))
    , ((2,'c'), (9,' ',L))
    , ((2,' '), (9,' ',L))
    , ((2,'y'), (6,'y',R))
    , ((3,'a'), (3,'a',R))
    , ((3,'b'), (4,'y',R))
    , ((3,'c'), (9,' ',L))
    , ((3,' '), (9,' ',L))
    , ((3,'y'), (4,'y',R))
    , ((4,'a'), (9,' ',L))
    , ((4,'b'), (9,' ',L))
    , ((4,'c'), (5,'z',L))
    , ((4,'z'), (4,'z',R))
    , ((4,' '), (9,' ',L))
    , ((5,'a'), (5,'a',L))
    , ((5,'x'), (2,'x',R))
    , ((5,'y'), (5,'y',L))
    , ((5,'z'), (5,'z',L))  
    , ((6,'a'), (9,' ',L))
    , ((6,'b'), (9,' ',L))
    , ((6,'c'), (9,' ',L))
    , ((6,'z'), (6,'z',R))
    , ((6,' '), (7,' ',L))
    ----leave Y
    , ((7,'x'), (7,' ',L))
    , ((7,'y'), (7,' ',L))
    , ((7,'z'), (7,' ',L))
    , ((7,' '), (8,'Y',L))
    ----leave N
    , ((9,'a'), (9,' ',L))
    , ((9,'b'), (9,' ',L))
    , ((9,'c'), (9,' ',L))
    , ((9,'x'), (9,' ',L))
    , ((9,'y'), (9,' ',L))
    , ((9,'z'), (9,' ',L))
    , ((9,' '), (10,'N',L))
    ]