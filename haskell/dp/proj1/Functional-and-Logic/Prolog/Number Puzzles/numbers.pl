%% File     : numbers.pl
%% Author   : Liang Han, Peter Schachte
%% Login ID : liangh2
%% Purpose  : This program is to solve the number puzzles, which inclueds 
%%            9 predicates. puzzle_solution/1 is the main predicate that
%%            should be invocated to sovle puzzles.

%% Load the library "clpfd" which makes transpose/2 available.
:- ensure_loaded(library(clpfd)).

%% puzzle_solution/1 is the main predicate that should be invocated to make
%% "Puzzle" ground. The paramter is the list representing the puzzle. It makes
%% sure that puzzle has equal diagonal elements firstly, then transpose the 
%% puzzle. Append the tranpsed puzzle list to original puzzle list getting 
%% complete puzzle list "P". Finally, use fill_puzzle/1 to slove the list "P". 
%% Once "P"is bound, the original puzzle is bound coresspondingly.
puzzle_solution([X|XS]):-
	same_diagonal([X|XS]),transpose([X|XS],[_|YS]),append(XS,YS,P),
	fill_puzzle(P).

%% same_diagonal/1 is to make sure all the diagonal elements in a puzzle are
%% equal. It firstly get the number of elements of a row "N" and then get the
%% first diagonal element "E". "N" and "E" are set as the arguements of 
%% same_diagonal1/3 to make comparasion to the remaining diagonal elements.
same_diagonal([X,Y|Rest]):-
	length(X,N),nth1(2,Y,E),same_diagonal1(Rest,N,2,E).

%% same_diagonal1/3 is the helper predicate to make the diagonal element on
%% the second and afterwards rows equal to the first diagonal element on the 
%% first row.
same_diagonal1([],A,A,_).
same_diagonal1([X|Rest],A,B,E):-
		B < A,B1 is B + 1,nth1(B1,X,E1),E1 = E, same_diagonal1(Rest,A,B1,E).

%% fill_puzzle/1 is the recursive predicate to fill the complete puzzle list 
%% one by one. It uses bagof/3 to get to get all the possbile solutions list 
%% "L" to each list element. member/2 assures X comes from solution list "L".
fill_puzzle([]).
fill_puzzle([X|XS]):-
	bagof(X,check_solution(X),L),member(X,L),fill_puzzle(XS).

%% check_solution/1 uses bind_value/1 to try all possible fillings of current
%% list element. It then assures elements in filling squares are distinct for 
%% each puzzle list element. Finally it meet constraints of sum or production
%% of digits in filling squares is equal to the header number.
check_solution([X|XS]):-
	bind_value(XS),all_different(XS),(product_list(XS,X);sumlist(XS,X)).

%% bind_value/1 is used to bind values to each unbound terms for each 
%% puzzle list element with digits in puzzle_digit/1.
bind_value([]).
bind_value([X|XS]):-
	puzzle_digit(X),bind_value(XS).

%% puzzle_digit/1 is the predicate to bind values to an unbound term by digits
%% from 1 to 9.
puzzle_digit(X):-
	X=1;X=2;X=3;X=4;X=5;X=6;X=7;X=8;X=9.

%% product_list/2 is the predicate that calcuates the production a list. 
%% Paramter X is the list and P is production.
product_list(X,P):-
	product_list1(X,1,P).

%% product_list1/3 is predicate that help get the predicate_list. "P" is final
%% production and N stores temporary production in each recursion.
product_list1([],N,N).
product_list1([X|XS],N,P):-
	N1 is X * N,product_list1(XS,N1,P).