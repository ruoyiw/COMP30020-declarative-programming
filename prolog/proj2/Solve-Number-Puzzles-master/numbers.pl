%  File     	: numbers.pl
%  Student ID   : 780052
%  Author   	: Shuangquan Lyu
%  Purpose  	: Prolog solving number puzzles
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Define the solution by defining a predicate puzzle_solution/1:
%%	 puzzle_solution(Puzzle).
%%  where Puzzle will be a proper list of proper lists,
%% A numbers puzzle will be represented as a list of lists,
%%  each of the same length, representing a single row of the puzzle.
%% The first element of each list is considered to be the header for that row.
%% Each element but the first of the first list in the puzzle is considered to be
%%  the header of the corresponding column of the puzzle.
%% The first element of the first element of the list is the corner square of the puzzle,
%%  and thus is ignored.
%% The way I do it is checking each row and column seperately to see whether all of them meet all the requirements.
%% As long as some requirement is not met, cut the search to save time.
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Define the solution predicate and relative predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- ensure_loaded(library(clpfd)).

% puzzle_solution([[_,Col1,Col2], [Row1,Row1Col1,Row1Col2], [Row2,Row2Col1,Row2Col2]])
% Pattern match: for 2*2 puzzle.
% First check whether the numbers on the diagonal line from upper left to lower right.
%  If not equal, cut the search to save time.
% Then use the predicate valid/1 to check each row and each column, ensure that they meet the requirements.
%  If any row or any column failed to meet the requirements, then cut the search.

puzzle_solution([[_,C1,C2], [R1,R11,R12], [R2,R21,R22]]) :-
	R11 = R22,
	valid([R1,R11,R12]),
	valid([R2,R21,R22]),
	valid([C1,R11,R21]),
	valid([C2,R12,R22]).

% puzzle_solution([[_,Col1,Col2,Col3], [Row1,Row1Col1,Row1Col2,Row1Col3], [Row2,Row2Col1,Row2Col2,Row2Col3],
%	 [Row3,Row3Col1,Row3Col2,Row3Col3]])
% Pattern match: for 3*3 puzzle.
% The same process as the one for 2*2 puzzle.

puzzle_solution([[_,C1,C2,C3], [R1,R11,R12,R13], [R2,R21,R22,R23], [R3,R31,R32,R33]]) :-
	R11 = R22, R22 = R33,
	valid([R1,R11,R12,R13]),
	valid([R2,R21,R22,R23]),
	valid([R3,R31,R32,R33]),
	valid([C1,R11,R21,R31]),
	valid([C2,R12,R22,R32]),
	valid([C3,R13,R23,R33]).

% puzzle_solution([[_,Col1,Col2,Col3,Col4], [Row1,Row1Col1,Row1Col2,Row1Col3,Row1Col4], [Row2,Row2Col1,Row2Col2,Row2Col3,Row2Col4],
%	 [Row3,Row3Col1,Row3Col2,Row3Col3,Row3Col4]], [Row4,Row4Col1,Row4Col2,Row4Col3,Row4Col4])
% Pattern match: for 3*3 puzzle.
% The same process as the one for 2*2 puzzle.

puzzle_solution([[_,C1,C2,C3,C4], [R1,R11,R12,R13,R14], [R2,R21,R22,R23,R24], [R3,R31,R32,R33,R34], [R4,R41,R42,R43,R44]]) :-
	R11 = R22, R22 = R33, R33 = R44,
	valid([R1,R11,R12,R13,R14]),
	valid([R2,R21,R22,R23,R24]),
	valid([R3,R31,R32,R33,R34]),
	valid([R4,R41,R42,R43,R44]),
	valid([C1,R11,R21,R31,R41]),
	valid([C2,R12,R22,R32,R42]),
	valid([C3,R13,R23,R33,R43]),
	valid([C4,R14,R24,R34,R44]).

% valid/1
% This is a predicate used in each puzzle_solution to check whether a row/column of the puzzle meet all the requirements.
% First make sure all the elements except the header is a single digit 1-9. If not, cut the search.
% Next make sure there are no repeated digits. 
% Then make sure the header of the list is the sum or the product of the rest elements.

valid([X|Xs]) :-
	inrange(Xs),
	norepeat(Xs),
	(check_sum(X, Xs, 0, S); check_multiply(X, Xs, 1, A)).

% norepeat/1
% Make sure all the elements in the list are not equal.
% First compare the first two element, and then recursively compare the others.
% For example, for [1,2,3,4,5], first compare 1 and 2, then check [1|3,4,5] and [2|3,4,5].
%  After [1|3,4,5] is [1|4,5] and [3|4,5], until there remains only one element.

norepeat([X]).
norepeat([X, X1|Xs]) :-
	X \= X1,
	norepeat([X|Xs]),
	norepeat([X1|Xs]).

% inrange/1
% Make sure the element is a single digit in 1-9.

inrange([]).
inrange([X|Xs]) :-
	between(1,9,X),
	inrange(Xs).


% check_sum(Target, List, Accumulator, Sum)
% check/4 is used to check whether the header of a list is the sum of the rest elements.
% Target is the header of the list. List is the rest of the elements.
% Accumulator is the used to as an accumulator. Sum is just the sum to be compared with the Target.

check_sum(Target, [], S, S) :-
	Target = S.
check_sum(Target, [X|Xs], A, S) :-
	Accu is A+X,
	check_sum(Target, Xs, Accu, S).

% check_multiply(Target, List, Accumulator, Product)
% check/4 is used to check whether the header of a list is the product of the rest elements.
% Target is the header of the list. List is the rest of the elements.
% Accumulator is the used to as an accumulator. Product is just the product to be compared with the Target.

check_multiply(Target, [], A, A) :-
	Target = A.
check_multiply(Target, [X|Xs], A, S) :-
	Accu is A*X,
	check_multiply(Target, Xs, Accu, S).
