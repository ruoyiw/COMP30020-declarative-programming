/*
------------------------------------------------------------------------
    Declarative Programming COMP30020 Assignment 2
    Student name: Ruoyi Wang
    Student No.: 683436
------------------------------------------------------------------------
*/


% Q1

correspond(E1, [E1|_], E2, [E2|_]).
correspond(E1,[_|T1], E2, [_|T2]) :- 
    correspond(E1, T1, E2, T2).


% Q2

samelength([], []).
samelength([_|Xs], [_|Ys]) :- 
    samelength(Xs, Ys).

samelength1([]).
samelength1([L]).
samelength1([L1, L2|Ts]) :-
    samelength(L1, L2),
    samelength1([L2|Ts]).

equallengthlist([], []).
equallengthlist([[]|Ts], Ys) :-
    equallengthlist(Ts, Ys).
equallengthlist([[_|Ts]|Xs], [_|Ys]) :-
    equallengthlist([Ts|Xs], Ys).


interleave(Ls,L) :-
    equallengthlist(Ls, L),
    samelength1(Ls),
    interleave1(Ls, L).


interleave1([], []).
interleave1([[]|T], []) :-
    interleave1(T, []).
interleave1([[Head|Tail]|Xs], [Head|Ys]):-
    append(Xs, [Tail], Zs),
    interleave1(Zs, Ys).
         
        
% Q3

partial_eval(Expr0, Var, Val, Expr) :- 
    (num_or_atom(Expr0, Var, Val, Expr);
     Expr0 = A0 + B0, partial_eval(A0, Var, Val, A), partial_eval(B0, Var, Val, B), 
        (number(A), number(B), Expr is A + B; 
         number(A), (atom(B); cal(B)), Expr =  A + B; 
         number(B),  (atom(A); cal(A)),Expr =  A + B; 
         atom(A), (atom(B); cal(B)), Expr =  A + B;
         cal(A), (atom(B); cal(B)), Expr =  A + B    
        );  
     Expr0 = A0 - B0, partial_eval(A0, Var, Val, A), partial_eval(B0, Var, Val, B),
        (number(A), number(B), Expr is A - B; 
         number(A), (atom(B); cal(B)), Expr = A - B; 
         number(B),  (atom(A); cal(A)),Expr = A - B; 
         atom(A), (atom(B); cal(B)), Expr = A - B;
         cal(A), (atom(B); cal(B)), Expr = A - B          
        ); 
     Expr0 = A0 * B0, partial_eval(A0, Var, Val, A), partial_eval(B0, Var, Val, B), 
        (number(A), number(B), Expr is A * B; 
         number(A), (atom(B); cal(B)), Expr = A * B; 
         number(B),  (atom(A); cal(A)),Expr = A * B; 
         atom(A), (atom(B); cal(B)), Expr = A * B;
         cal(A), (atom(B); cal(B)), Expr = A * B           
        ); 
     Expr0 = A0 / B0, partial_eval(A0, Var, Val, A), partial_eval(B0, Var, Val, B), 
        (number(A), number(B), Expr is A - B; 
         number(A), (atom(B); cal(B)), Expr = A / B; 
         number(B),  (atom(A); cal(A)),Expr = A / B; 
         atom(A), (atom(B); cal(B)), Expr = A / B;
         cal(A), (atom(B); cal(B)), Expr = A / B           
        ); 

     Expr0 = A0 // B0, partial_eval(A0, Var, Val, A), partial_eval(B0, Var, Val, B), 
        (number(A), number(B), Expr is A // B; 
         number(A), (atom(B); cal(B)), Expr =  A // B; 
         number(B),  (atom(A); cal(A)),Expr = A // B; 
         atom(A), (atom(B); cal(B)), Expr =  A // B;
         cal(A), (atom(B); cal(B)), Expr =  A // B            
        )
    ).
    
cal(Expr0) :- 
    (Expr0 =  A + B; 
     Expr0 =  A - B; 
     Expr0 =  A * B; 
     Expr0 =  A / B; 
     Expr0 =  A // B
    ).  

num_or_atom(Expr0, Var, Val, Expr) :-
    (number(Expr0),
     Expr = Expr0;
     atom(Expr0),
        (Expr0 = Var,
         Expr = Val;
         Expr0 \= Var,
         Expr = Expr0)
    ).
    
     
    
