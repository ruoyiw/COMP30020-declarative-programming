% Q2
same_elements(L1, L2) :-
    sort(L1,S1),
    sort(L2,S2),
    S1 = S2.

% Q3
times(W,X,Y,Z) :-
    ( integer(W), integer(X),  integer(Y), integer(Z),
          Z is W*X+Y
    ; integer(Z)  (
          integer(X)
              divmod(Z,X,W,Y)
    ;     integer(W)
              divmod(Z,W,X,Y)
    ;
          throw(error(instantiation_error,context(times/4,_)))  
      


% Q4
 
containers(Steps) :-
    containers(3, 5, 0, 0, _, 4, [0-0], Steps).


containers(_,_,V1,V2,V1,V2,_,[]).
containers(C1,C2,V1,V2,T1,T2,History,[Move|Steps]) :-
    move(C1,C2,V1,V2,N1,N2,Move),
    state = N1-N2,
    \+ member(State,History),
    containers(C1,C2,N1,N2,T1,T2,[State|History],Steps).

move(C1,_,V1,0,V1,V2,empty(C1)).
move(_,C2,V1,V2,V1,0,empty(C2)).
move(C1,_,V1,V2,C1,V2,fill(C1)).
move(_,C2,V1,V2,V1,C2,empty(C2)).
move(C1,C2,V1,V2,N1,N2,pour(C2,C1) :-
    pour(C2,V2,V1,N2,N1).

pour(Cap, FromBefore, ToBefore, FromAfter, ToAfter) :-
    


           
