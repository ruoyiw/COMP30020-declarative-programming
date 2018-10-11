% Q1

sumlist(List, Sum) :-
	sumlist(List, 0, Sum).

sumlist([], Sum, Sum).
sumlist([N|Ns], Sum0, Sum) :-
	Sum1 is Sum0 + N,
	sumlist(Ns, Sum1, Sum).


% Q2

tree(empty).
tree(node(Left, _, Right)) :-
    tree(Left),
    tree(Right).

tree_list(empty, []).
tree_list(node(L,V,R),List) :-
    tree_list(L, LList),
    tree_list(R, RList),
    append(LList, [V|RList], List). 


% Q3
tree_list(Tree, List) :-
	tree_list1(Tree, List, []).

% List is the list of the elements of Tree with List0 appended to the end
tree_list1(empty, List, List).
tree_list1(node(L,V,R), List, List0) :-
    tree_list(L, List, List1),
    List1 = [V|List2],
    tree_list(R, List2, List0).


% Q4

list_tree([], empty).
list_tree([E|List], node(Left,Elt,Right)) :-
	length(List, Len),
	Len2 is Len // 2,
	length(Front, Len2),
	append(Front, [Elt|Back], [E|List]),
	list_tree(Front, Left),
	list_tree(Back, Right).      
