formula_intersection(x=X, y=Y, X, Y) :- number(X), number(Y).
formula_intersection(y=Y, x=X, X, Y):- number(X), number(Y).
formula_intersection('='(y,'+'('*'(B,x),Const)), x=X, 
	X, Y) :-
    Y is (B * X) + Const,
    number(Y).
formula_intersection(x=X, 
	'='(y,'+'('*'(B,x),Const)), 
	X, Y) :-
    Y is '+'('*'(B,X),Const),
    number(Y).
formula_intersection(y = BLHS*x + ConstLHS, 
	y = BRHS*x + ConstRHS, 
	X, Y) :-
    X is (ConstLHS - ConstRHS) / (BLHS - BRHS),
    Y is (BLHS*X) + ConstLHS,
    number(X),
    number(Y).