formula_intersection(x=X, y=Y, X, Y) :- number(X), number(Y).
formula_intersection(y=Y, x=X, X, Y):- number(X), number(Y).
formula_intersection('='(y,'+'('*'(NegB,x),NegConst)), x=X, 
	X, Y) :-
    Y is (NegB * X) + NegConst,
    number(Y).
formula_intersection(x=X, 
	'='(y,'+'('*'(NegB,x),NegConst)), 
	X, Y) :-
    Y is '+'('*'(NegB,X),NegConst),
    number(Y).
formula_intersection(y = NegBLHS*x + NegConstLHS, 
	y = NegBRHS*x + NegConstRHS, 
	X, Y) :-
    X is (NegConstLHS - NegConstRHS) / (NegBLHS - NegBRHS),
    Y is (NegBLHS*X) + NegConstLHS,
    number(X),
    number(Y).