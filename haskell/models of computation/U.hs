module U
where
import RunTM

{------------------------------------------------------------------------
   COMP30026 Models of Computation
   Assignment 2, 2016
   Question 4
   Student Name: Ruoyi Wang
   Student Number: 683436
------------------------------------------------------------------------}

u :: TM
u
  = [ ((1,' '), (2,' ',R))
    , ((2,'a'), (3,'x',R))
    , ((2,'b'), (5,'b',L))
    , ((2,'c'), (12,' ',L))
    , ((2,'z'), (12,' ',L))
    , ((2,' '), (12,' ',L))
    , ((3,'a'), (3,'a',R))
    , ((3,'b'), (3,'b',R))
    , ((3,'z'), (3,'z',R))  
    , ((3,'c'), (4,'z',L))
    , ((3,' '), (12,' ',L))
    , ((4,'a'), (4,'a',L))
    , ((4,'b'), (4,'b',L))
    , ((4,'z'), (4,'z',L))
    , ((4,'x'), (2,'x',R)) -- elimanate all 'a'
    , ((5,'x'), (6,'x',R)) -- make sure 'a' has been there
    , ((5,' '), (12,' ',L))
    , ((6,'b'), (7,'y',R))  
    , ((6,'z'), (9,'z',R))
    , ((7,'a'), (12,' ',L))
    , ((7,'z'), (7,'z',R))
    , ((7,'b'), (7,'b',R))
    , ((7,'c'), (8,'z',L))
    , ((7,' '), (12,' ',L))
    , ((8,'b'), (8,'b',L))
    , ((8,'z'), (8,'z',L))
    , ((8,'y'), (6,'y',R)) -- elimanate all 'b'
    , ((9,'c'), (12,' ',L))
    , ((9,'z'), (9,'z',R))
    , ((9,' '), (10,' ',L))
    ---- leave Y
    , ((10,'z'), (10,' ',L))
    , ((10,'y'), (10,' ',L))
    , ((10,'x'), (10,' ',L))
    , ((10,' '), (11,'Y',L))
    ---- leave N
    , ((12,'a'), (12,' ',L))
    , ((12,'b'), (12,' ',L))
    , ((12,'c'), (12,' ',L))
    , ((12,'x'), (12,' ',L))
    , ((12,'y'), (12,' ',L))
    , ((12,'z'), (12,' ',L))
    , ((12,' '), (13,'N',L))
    ]