%% Question 1

correspond(E1,[E1|_],E2,[E2|_]).
correspond(E1, [_|XS], E2, [_|YS]):-
	correspond(E1,XS,E2,YS).

%%Question 2


%% interleave([X|XS],L):-
%% 	length(X,N),
%% 	length([X|XS],M),
%% 	interleave1([X|XS],L),
%% 	ifsamelength([X|XS],0,N,M).

%% interleave1([[]],[]).
%% interleave1([Head|Tail],[]):-
%% 	Head = [],
%% 	interleave1(Tail,[]).
%% interleave1([[X|XS]|YS],L):-
%% 	append(YS,[XS],LS),
%% 	append([X],L1,L),
%% 	interleave1(LS,L1).	


interleave(LS,L):-interleave1(LS,LS,L).
interleave1([X|XS],LS,L):-
	(var(L)->
		length(X,N),length(LS,M),
		ifsamelength2(LS,0,N,M),
		get_l([X|XS],[],L,1,N,1,M)
		;\+ var(L) ->
		length(LS,M),length(L,A),
		N is A/M,
		%% ifsamelength([X|XS],A),
		makesamelength(N,M,[],L1,A),
		get_l(L1,[],L,1,N,1,M),
		append(L1,[],[X|XS])
	).
	
	
		%% ifsamelength([X|XS],0,N,M,A),
		
	

get_l([X|XS],LA,L,NA,N,MA,M):-
	(NA >= N,MA > M->
		reverse(LA,L)
	;MA =< M ->
		nthele(X,NA,E),
		append([E],LA,LA1),
		MA1 is MA +1,
		append(XS,[X],LS),
		get_l(LS,LA1,L,NA,N,MA1,M)
	;MA > M->
		NA1 is NA +1,
		%% append(XS,[X],LS),
		get_l([X|XS],LA,L,NA1,N,1,M)
	).

nthele([X|XS],N,E):-
	(N =:= 1 ->
		E = X
	; N > 0,
		N1 is N -1,
		nthele(XS,N1,E)
	).

ifsamelength2([],A,_,M):-
	A = M.
ifsamelength2([Y|YS],A,N,M):-
		length(Y,N1),
		(N1 =:= N ->
		A1 is A +1,
		ifsamelength2(YS,A1,N,M)
		).

ifsamelength([_|[]],1).
ifsamelength([X1,X2|XS],L):-
	samelength(X1,X2),
	%% A1 is A -1,
	L1 is L -1,
	ifsamelength([X2|XS],L1).
	
	%% ; N1 =\= N >0->
	%% 	L1 is L - N1,
	%% 	ifsamelength(YS,A,N,M,L1)
	%% ).

samelength([],[]).
samelength([_|Xs],[_|Ys]):-
	samelength(Xs,Ys).


makesamelength(B,LA,A,L,N):-
	( LA =:= 0 ->
		L = A;
	  LA >0 ->
		length(X1,B),
		append(A,[X1],A1),
		LA1 is LA - 1,
		makesamelength(B,LA1,A1,L,N)
		).


%% Question 3

partial_eval(Expr0,Var,Val,Expr):-
	Expr0=..List,
	transterm(List,Var,Val,[],Expr,0,_,0,_).

transterm([],_,_,TL,T,TN,N,TA,A):- 
	reverse(TL,RTL),
	T1 =.. RTL,
	N is TN,
	A is TA,
	(N is A + 1 ->
		T is T1
	;\+ N is A + 1 ->
		T = T1
	).


transterm([X|XS],Var,Val,TList,Term,TNum,Num,TAtom,Atom):-
	(atom(X),X = Var->
	append([Val],TList,TList1),
	TNum1 is TNum + 1,
	transterm(XS,Var,Val,TList1,Term,TNum1,Num,TAtom,Atom)
	;atom(X),\+ X = Var ->
	append([X],TList,TList1),
	TAtom1 is TAtom + 1,
	transterm(XS,Var,Val,TList1,Term,TNum,Num,TAtom1,Atom)
	;number(X) ->
	append([X],TList,TList1),
	TNum1 is TNum + 1,
	transterm(XS,Var,Val,TList1,Term,TNum1,Num,TAtom,Atom)
	;\+number(X),\+atom(X),\+ X =Var ->
	X =.. SubList,
	transterm(SubList,Var,Val,[],SubTerm,0,SubNum,0,SubAtom),
	TNum1 is TNum + SubNum,
	TAtom1 is TAtom + SubAtom,
	append([SubTerm],TList,TList1),
	transterm(XS,Var,Val,TList1,Term,TNum1,Num,TAtom1,Atom)
	).




