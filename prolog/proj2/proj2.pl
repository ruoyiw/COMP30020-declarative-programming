%  File       : proj2.hs
%  Author     : Ruoyi Wang
%  Student No.: 683436
%  Update     : 20:00 28 Sep 2017
%  Purpose    : Declarative Programming COMP30020 Project 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Define a predicate puzzle_solution/1:
%%	puzzle_solution(Puzzle) 
%% such that Puzzle a square grid of squares, each to be filled in with a single digit 1-9 
%% (zero is not permitted) satisfying these constraints:
%%     • each row and each column contains no repeated digits;
%%     • all squares on the diagonal line from upper left to lower right contain the same value; and
%%     • the heading of reach row and column (leftmost square in a row and topmost square in a column) 
%%       holds either the sum or the product of all the digits in that row or column
%% 
%% The row and column headings are not considered to be part of the row or column,
%% and so may be filled with a number larger than a single digit. 
%% The upper left corner of the puzzle is not meaningful.
%% The goal of the puzzle is to fill in all the squares according to the rules.
%% A proper maths puzzle will have at most one solution.
%%
%%
%% In this program, the puzzle was checked if it is a square by maplist(same_length(Puzzle), Puzzle),
%% each row and column was checked by check_rows/1, check_columns/1 
%% (columns can be checked by checking the rows of the transposed puzzle), 
%% and all the squares on the diagonal were unified by unify_diagonal/3, to ensure puzzle is valid 
%% as soon as it is generated, rather than generating the whole grid before checking. 
%% The search space can be enormously constrained by predicates like sumlist/2 and multiplylist/2.
%% After setting all the domain limits, it is very efficient to backtrack over the possible values for 
%% each puzzle square. Then each empty square in the puzzle was labeled by maplist(label, puzzle).
%% The predicate ground(Puzzle) will return true if the puzzle has been bound to a valid solution.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- ensure_loaded(library(clpfd)).

%% puzzle_solution(Puzzle) 
%% Return a solution to the puzzle with ground arguments.
%% The puzzle is a proper list of proper lists, and all the header squares of the puzzle 
%% (plus the ignored corner square) are bound to integers. 
%% Some of the other squares in the puzzle may also be bound to integers, 
%% but the others will be unbound. 
puzzle_solution(Puzzle) :- 
    maplist(same_length(Puzzle), Puzzle),
    Puzzle = [HeadRow|TailRows],
    unify_diagonal(TailRows, 1, _), 
    check_rows(TailRows), 
    check_columns(Puzzle),
    maplist(label, Puzzle),
    ground(Puzzle).


%% unify_diagonal(TailRows, N, Square)
%% Unify all the squares on the diagonal line from upper left to lower right.
%% TailRows are the tail rows of the puzzle, as the header row was cut off.
%% N is the index of diagonal square in a given list, should start with N = 1.
%% The value of squares at position Ns should keep same.
unify_diagonal([], _, _).
unify_diagonal([Head|Tail], N, Square) :-
    nth0(N, Head, Square),
    N1 #= N + 1,
    unify_diagonal(Tail, N1, Square).


%% sumlist(L, Sum)
%% Sum all elements in the input list by calling sum/3, 
%% which is a predicate defined in the library(clpfd).
sumlist(L, Sum) :-
    sum(L, #=, Sum).


%% multiplylist(L, Product)
%% Multiply all elements in the input list by calling multiplylist/3.
multiplylist(L, Product) :- 
    multiplylist(L, 1, Product).


%% multiplylist(List, Acc, Product)
%% The tail recursive version to perform the multiplication by adding an accumulator Acc.
%% The Product is the product of elements in the List times Acc.
%% The Acc is taken as 1 for the initial call.
multiplylist([], Product, Product).
multiplylist([H|T], Acc, Product) :-
    Acc1 #= H * Acc,
    multiplylist(T, Acc1, Product).


%% check_row(List)
%% Constrain the list elements within the range of 1 to 9
%% and check no repeated elements in the list.
%% Then check if the first element (header) of a given list is equal to the sum or product 
%% of the other elements. 
check_row([Header|Tail]) :-
    Tail ins 1..9,
    all_distinct(Tail),
    ( sumlist(Tail, Header)
    ; multiplylist(Tail, Header)
    ).



%% check_rows(TailRows)
%% Check if the tail rows of the puzzle follow the contraints,
%% by using maplist(check_row, TailRows) to validate each row in the tail rows.
check_rows(TailRows) :-
    maplist(check_row, TailRows).


%% check_columns(Puzzle)
%% Transpose the puzzle to make the columns become rows, 
%% so the columns can be checked by checking the rows of the transposed puzzle. 
check_columns(Puzzle) :-
    transpose(Puzzle, [_|TailRows]),
    check_rows(TailRows).



