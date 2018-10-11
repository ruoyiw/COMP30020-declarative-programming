% File		: numbers.pl
% Author	: Russell Long - 576494
% Created	: 11/10/2015
%
% Created for COMP90048 project 2
%
% This programs main predicate is puzzle_solution/1.
% It takes in a 2d array of integer values that represent rows in a table.
% The first row and the first column represent what each row and column
% should add up to OR multiply into resepectively.
%
% example: Puzzle=[[0,14,10,35],[14,_,_,_],[15,_,_,_],[28,_,1,_]]
% This is a puzzle where the columns, in order, need to add/multiply to 14, 10 and 35. 
% The first 0 is a place holder and is irrelevant. The rows in order need to
% add/multiply to 14, 15 and 28.
% 
% Each other number can either exist or not. The diagonal of the table should
% all be the same number. This programs purpose is to solve this puzzle, 
% returning a table in the same format with all the numbers filled in. 
% There should be only a single solution.

:- ensure_loaded(library(clpfd)).

%Test predicate for quickly running the program
runner(_) :-
	Sample=[[0,1680,36,27,60],[17,_,_,_,_],[28,_,_,9,_],[180,_,_,_,_],[168,_,_,_,_]],
	puzzle_solution(Sample).


%Required entry point to the program. This takes in a puzzle as defined above.
%This will return a solution to the puzzle.
puzzle_solution(Puzzle) :- 
	
	getVars(Puzzle, Vars),
	unifyDiag(Vars, 0),
	Puzzle = [PuzzH|PuzzT],
	generate(PuzzT, Vars),
	checkCols(Puzzle),
	print(Puzzle),!.



%generate(Puzzle, Vars):
%	Takes in the ROWS of a puzzle, header row must be split off before 
%	being put in. Vars are the list of variables that can be changed by label
%	and correspond directly to the variables in PuzzH
%	e.g. PuzzH has a header number, followed by variables contained in VarsH
%	This generates and tests rows so there is a smaller sample space
generate([], _).
generate(_,[]).
generate([PuzzH|PuzzT], [VarsH|VarsT]) :-
	VarsH ins 1..9,
	label(VarsH),
	all_distinct(PuzzH),
	checkRow(PuzzH),
	generate(PuzzT, VarsT).
	
% a runner predicate that checks constraints for columns
% checkCol(Puzzle) Takes in a full puzzle, including headers. 
% Is true if a column add/multiplies to first number, and if all numbers in
% each col are unique
checkCols(Puzzle) :-
	transpose(Puzzle, Trans),
	[_|Cols] = Trans,
	checkConsistancy(Cols),
	checkDistinct(Cols).

% check if all the variables in a list are all_distinct
% checkDistinct(Rows), where Rows(can also be columns) is a list of lists
% The first number get stripped away as this is a header number, and the rest
% is checked if it is distinct. checks all rows
checkDistinct([]).
checkDistinct([ColsH|ColsT]) :-
	ColsH = [_|Vars],
	all_distinct(Vars),
	checkDistinct(ColsT).

% entry point for unifying diagonals
% unifyDiag(Vars, Pos) where Vars is a list of list of all variables in the
% puzzle in order they exist in the real puzzle. Pos should be 0 on first call
unifyDiag([VarsH|VarsT], Pos) :- 
	nth0(Pos, VarsH, First),
	unifyDiag(VarsT, 1, First).

% unifies each diagonal square
% unifyDiag(Vars, Pos, Prev) where Vars is as above, Pos is the position we
% are up to in the diagonals so we know which point to reference, and Prev
% is the sqaure from the previous call to unifyDiag, so we can make it unify
% with the next one.
unifyDiag([],_,_).
unifyDiag([VarsH|VarsT], Pos, Prev) :-
	Pos > 0,
	nth0(Pos, VarsH, Next),
	Next = Prev,
	NextPos is Pos+1,
	unifyDiag(VarsT, NextPos, Next).


% Check if the diagonals of the puzzle are all the same
% checkDiag(PuzzleRows, Num, Pos) where PuzzleRows is the initial Puzzle with 
% the header row cut off. Num is initially 0, and gets set to the first diagonal
% value. Pos is the position we are up to in checking diagonals.
checkDiag([],_,_).
checkDiag([RowsH|RowsT], 0, Pos) :- 
	nth0(Pos, RowsH, Next),
	NextPos is Pos+1,
	checkDiag(RowsT, Next, NextPos).
checkDiag([RowsH|RowsT], Num, Pos) :-
	Num > 0,
	nth0(Pos, RowsH, Next),
	Num = Next,
	NewPos is Pos+1,
	checkDiag(RowsT, Next, NewPos).


% This predicate checks the addition and sumation consistancy of all puzzle rows
% checkConsistancy(Rows) where Rows is again, the puzzle minus the heading line
% For columns, you can transpose the puzzle and cut the header off.
% This program no longer needs to check Rows, so this is only used to check
% that columns are consistant
checkConsistancy([]).
checkConsistancy(Rows) :-
	exclude(sum, Rows, Rest),
	maplist(multList, Rest).

% A simple entry point for sum_list so that sum_list can be called with
% a row that still has its header number, for defining what the row should
% add to
% sum([RowH|RowT]), where RowH is the number that a row needs to add/multiply
% to, and RowT is the rest of the numbers for the checking
sum([RowH|RowT]) :- sum_list(RowT, RowH). 


% This predicate returns all of the numbers in the puzzle that are not a part of
% the header row or column.
% getVars(Puzzle, Vars) where Puzzle is the whole Puzzle, and vars is what's 
% returned. Vars is set to be in the same positions as Puzzle for easier use
% e.g. Puzzle = [[0,1,2], [3,4,5], [6,7,8]] -> Vars = [[4,5], [7,8]]
getVars(Puzzle, Vars) :-
	Puzzle = [_|PuzzT],
	transpose(PuzzT, TransPuzz),
	TransPuzz = [_|Vars1],
	transpose(Vars1, Vars).
	%flatten(Vars1, Vars).

% This predicate checks that the tail of the input list multiplies to the
% head of the input list, by calling multList/3
multList([VarH|VarT]) :- multList(VarT, VarH, 1).

% This predicate checks that the given list multiplies to Total
% multList(List, Total, Acc) where Total is the amount that we want to check to
% see if the List multiplies to, and Acc is an accumulator.
% initial call should take 1 in for the Acc.
multList([], T, T).
multList([H|T], Total, Acc) :-
	Acc2 is H*Acc,
	multList(T, Total, Acc2).

checkRow(Row) :- sum(Row).
checkRow(Row) :- multList(Row).
