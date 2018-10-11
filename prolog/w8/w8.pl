% q1

list_of(_, []).
list_of(Elt, [Elt|List]) :-
	listof(Elt, List).

% q2

all_same(List) :-
	listof(_, List).

% q3

adjacent(E1, E2, List) :-
        append(_, [E1, E2|_], List).


% q4

adjacent(E1, E2, [E1, E2|_]).
adjacent(E1, E2, [_|Rest]) :-
        adjacent(E1, E2, Rest).
% q5

before(E1, E2, [E1|List]) :-
	member(E2, List).
before(E1, E2, [_|List]) :-
	before(E1, E2, List).


%  q6

intset_member(N, tree(_,N,_)).
intset_member(N, tree(L,N0,_)) :-
	N < N0,
	intset_member(N, L).
intset_member(N, tree(_,N0,R)) :-
	N > N0,
	intset_member(N, R).



intset_insert(N, empty, tree(empty,N,empty)).
intset_insert(N, tree(L,N,R), tree(L,N,R)).
intset_insert(N, tree(L0,N0,R), tree(L,N0,R)) :-
	N < N0,
	intset_insert(N, L0, L).
intset_insert(N, tree(L,N0,R0), tree(L,N0,R)) :-
	N > N0,
	intset_insert(N, R0, R).
        

