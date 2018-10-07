
get_last([],_, List) :- List = [] , !.
get_last([[Node1, Node2]|T], Node, List) :- Node = Node1, get_last(T, Node, List2),
											 List = [Node2|List2], !.
get_last(E, Node, List) :- E = [H|T], H = [_, _], get_last(T, Node, List2),
						 List = List2, !. 
getoutedges(G, Node,L) :- G = [_,E], get_last(E,Node,L).

%========================================================================================

%----------------------------------------------------------------------------------------
%-----------------------------------------valid------------------------------------------

verif(Formula, _, _, NewFormula) :- Formula = valid, NewFormula = valid, !.

%----------------------------------------------------------------------------------------
%-----------------------------------------future-----------------------------------------

verif(Formula, [Node, _], Dest, NewFormula) :- Formula = future(next(_)),
												Node = Dest, NewFormula = false, !.

verif(Formula, [Node, _], Dest, NewFormula) :- Formula = future(next(X)),
												 Node \= Dest, NewFormula = future(X), !.

verif(Formula, [_, Color], _, NewFormula) :- Formula = future(Color1),
												 Color1 = Color, NewFormula = valid, !.

verif(Formula, [_, Color], _, NewFormula) :- Formula = future(Color1),
												  Color1 \= Color, NewFormula =
												   future(Color1), !.

verif(Formula, [_, _], _, NewFormula) :- Formula = future(_), 
												  NewFormula = false, !.

%----------------------------------------------------------------------------------------
%------------------------------------------and-------------------------------------------

%true true
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = and(X, Y), verif(X,
 [Node, Color], Dest, NewFormula1),
verif(Y, [Node, Color], Dest, NewFormula2), NewFormula1 = valid, NewFormula2 =
 valid, NewFormula = valid, !.

%orice false
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = and(_, Y),
verif(Y, [Node, Color], Dest, NewFormula2), NewFormula2 = false, NewFormula = 
false, !.

%false orice
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = and(X, _), verif(X,
 [Node, Color], Dest, NewFormula1),
NewFormula1 = false, NewFormula = false, !.

%true orice
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = and(X, Y), verif(X,
 [Node, Color], Dest, NewFormula1),
verif(Y, [Node, Color], Dest, NewFormula2), NewFormula1 = valid, NewFormula =
 NewFormula2, !.

%orice true
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = and(X, Y), verif(X,
 [Node, Color], Dest, NewFormula1),
verif(Y, [Node, Color], Dest, NewFormula2), NewFormula2 = valid, NewFormula =
 NewFormula1, !.

%orice orice
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = and(X, Y), verif(X,
 [Node, Color], Dest, NewFormula1),
verif(Y, [Node, Color], Dest, NewFormula2), NewFormula = and(NewFormula1,
 NewFormula2), !.

%----------------------------------------------------------------------------------------
%-------------------------------------------or-------------------------------------------

%valid orice
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = or(X, _), verif(X,
 [Node, Color], Dest, NewFormula1),
NewFormula1 = valid, NewFormula = valid, !.

%orice valid
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = or(_, Y), verif(Y,
 [Node, Color], Dest, NewFormula2),
NewFormula2 = valid, NewFormula = valid, !.

%false false
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = or(X, Y), verif(X,
 [Node, Color], Dest, NewFormula1),
verif(Y, [Node, Color], Dest, NewFormula2), NewFormula2 = false, NewFormula1 =
 false, NewFormula = false, !.

%orice orice
verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = or(X, Y), verif(X,
 [Node, Color], Dest, NewFormula1),
verif(Y, [Node, Color], Dest, NewFormula2), NewFormula = or(NewFormula1,
 NewFormula2), !.

%----------------------------------------------------------------------------------------
%------------------------------------------next------------------------------------------

verif(Formula, [Node, _], Dest, NewFormula) :- Formula = next(_), Dest = Node,
 NewFormula = false, !.

verif(Formula, [_, _], _, NewFormula) :- Formula = next(X), NewFormula = X, !.

%----------------------------------------------------------------------------------------
%-----------------------------------------global-----------------------------------------

verif(Formula, [Node, _], Dest, NewFormula) :- Formula = global(next(_)), Node = Dest,
NewFormula = false, !.

verif(Formula, [Node, _], Dest, NewFormula) :- Formula = global(next(X)), Node \= Dest,
NewFormula = global(X), !.

verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = global(X), Node = 
Dest, X = Color,
NewFormula = valid, !.

verif(Formula, [_, Color], _, NewFormula) :- Formula = global(X), X = Color,
NewFormula = global(X), !.

verif(Formula, [_, Color], _, NewFormula) :- Formula = global(X), X \= Color,
NewFormula = false, !.

%----------------------------------------------------------------------------------------
%------------------------------------------not-------------------------------------------

verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = not(X), verif(X,
 [Node, Color], Dest, NewFormula1), NewFormula1 = false, NewFormula = valid, !.

verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = not(X), verif(X,
 [Node, Color], Dest, NewFormula1), NewFormula1 = valid, NewFormula = false, !.

verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = not(X), verif(X,
 [Node, Color], Dest, NewFormula1), Node = Dest, NewFormula = valid, !.

verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = not(X), verif(X,
 [Node, Color], Dest, NewFormula1), NewFormula = not(NewFormula1), !.

%----------------------------------------------------------------------------------------
%-----------------------------------------until------------------------------------------

verif(Formula, [_, Color], _, NewFormula) :- Formula = until(_, Color2),
Color2 = Color, NewFormula = valid, !.

verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = until(Color1, _),
Node = Dest, Color1 = Color, NewFormula = valid, !.

verif(Formula, [Node, Color], Dest, NewFormula) :- Formula = until(Color1, Color2),
Node \= Dest, Color1 = Color, NewFormula = until(Color1, Color2), !.

verif(Formula, [_, _], _, NewFormula) :- Formula = until(_, _),
 NewFormula = false, !.

%----------------------------------------------------------------------------------------
%-----------------------------------------color------------------------------------------

verif(Formula, [_, Color], _, NewFormula) :- Formula = Color, NewFormula = valid, !.

% this is my last resort
verif(_, [_, _], _, NewFormula) :- NewFormula = false. 

%========================================================================================

append_reverse([], Aux ,List) :- List = Aux, !.
append_reverse([H|T], Aux, List) :- append_reverse(T, [H|Aux], Listaux), List = Listaux.

nott(X) :- X, !, false.
nott(_).

get_color_aux(Node, [[Node, Color]|_], Colorr) :- Colorr = Color, !.
get_color_aux(Node, [[Node2, _]|T], Colorr) :- Node \= Node2, get_color_aux(Node,
 T, Coloraux), Colorr = Coloraux, !.

get_color(Node, [V, _], Color) :- get_color_aux(Node, V, Color).

% nu conteaza ca folosesc member pentru ca elementele dintr-un path nu se vor repeta
verif_nodes([], _, Unvisited) :- Unvisited = [], !.

verif_nodes([H|Nodes], Path, Unvisited) :- verif_nodes(Nodes, Path, Unvisited1),
 nott(member(H, Path)), Unvisited = [H|Unvisited1], !.

%din nefericire va face backtracking si va fi ineficient.
verif_nodes([H|Nodes], Path, Unvisited) :- verif_nodes(Nodes, Path, Unvisited1),
 member(H, Path), Unvisited = Unvisited1 , !.

%get a list of Element of sizeof second parameter

multiply_element(_, [], NewList) :- NewList = [], !.
multiply_element(Element, [_|T] ,NewList) :- multiply_element(Element, T, NewList2),
 NewList = [Element|NewList2].


appendd([], L2, L3) :- L3 = L2.
appendd([H|L1], L2, L3) :- appendd(L1, L2, Laux), L3 = [H|Laux].

member(E, [E|_]) :- !.
member(E, [_|T]) :- member(E, T).

%==============================================================================

% poti optimiza folosind un predicat.
bfs_crt([], _, _, [],[], NewNodes, Newformulas, NewPaths, _) :-
 Newformulas = [], NewNodes = [], NewPaths = [], !.

bfs_crt([Node|_], To, Graph, [Formula|_], [CrtPath|_], _, _, _, Finalpath) :-
 Node = To, get_color(Node, Graph, Color), verif(Formula, [Node, Color], To,
  NewFormula),
  NewFormula = valid, Finalpath = [Node|CrtPath], !.

bfs_crt([Node|Nodes], To, Graph, [Formula|Formulas], [CrtPath|Paths], NewNodes,
 Newformulas, NewPaths, Finalpath) :-
 get_color(Node, Graph, Color), verif(Formula, [Node, Color], To, NewFormula),
  NewFormula \= false, getoutedges(Graph, Node, Adj), verif_nodes(Adj, CrtPath,
   NodeList), multiply_element(NewFormula,
   NodeList, FormulaList), bfs_crt(Nodes, To ,Graph, Formulas, Paths, NewNodes1,
    Newformulas1, NewPaths1, Finalpath1),
  appendd(FormulaList, Newformulas1, Newformulas), appendd(NodeList, NewNodes1,
   NewNodes),
   multiply_element([Node|CrtPath], NodeList, PathList), appendd(PathList, NewPaths1,
    NewPaths),
    Finalpath = Finalpath1, !.

% stiu sigur ca e false Newformula de la pasul anterior. (Exista cut la final)
bfs_crt([_|Nodes], To, Graph, [_|Formulas], [_|Paths], NewNodes, Newformulas,
 NewPaths, Finalpath) :-
 bfs_crt(Nodes, To ,Graph, Formulas, Paths, NewNodes1, Newformulas1, NewPaths1,
  Finalpath1),
  NewNodes = NewNodes1, Newformulas = Newformulas1, NewPaths = NewPaths1,
   Finalpath = Finalpath1, !.


%==============================================================================


bfs(Nodes, To, Graph, Formulas, Paths, Finalpath) :- bfs_crt(Nodes, To, Graph,
 Formulas, Paths,
 NewNodes, NewFormulas, NewPaths, Finalpath1), Finalpath1 = 1, NewNodes \= [],
  bfs(NewNodes, To, Graph, NewFormulas, NewPaths, Finalpath), !.

bfs(Nodes, To, Graph, Formulas, Paths, Finalpath) :- bfs_crt(Nodes, To, Graph,
 Formulas, Paths,
 _, _, _, Finalpath1), nott(Finalpath1 = 1), Finalpath = Finalpath1, !.

%==============================================================================


getPath(From, To, Graph, Formula, Path) :- bfs([From|[]], To, Graph, 
	[Formula|[]], [[]|[]], Path1), !,
	 append_reverse(Path1, [], Path), !.

getPath(_, _, _, _,Path) :- Path = false.