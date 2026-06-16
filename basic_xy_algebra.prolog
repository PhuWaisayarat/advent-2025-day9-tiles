formula_intersection(formula(x=X), formula(y=Y), X, Y) :- number(X), number(Y).
formula_intersection(formula(y=Y), formula(x=X), X, Y):- number(X), number(Y).
formula_intersection(formula('='(y,'+'('*'(NegB,x),NegConst))), formula(x=X), 
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