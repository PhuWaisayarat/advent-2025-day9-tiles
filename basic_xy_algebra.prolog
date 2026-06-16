solveLinear(y=RHS, y=RHS, '/'('-'(y,C),B), RHS) :-
	RHS=B*x+C.
solveLinear(x=RHS, x=RHS, RHS, '+'('*'(B,x),C)) :-
	RHS='/'('-'(y,C),B).

solveLinear(y=RHS1, y= RHS2, X, Y):-
	RHS1 = B1*x+C1,
	RHS2 = B2*x+C2,
    	X is '/'((C2-C1), (B1-B2)),
    	Y is B1*X+C1.

solveLinear(y=N1, x=N2, N2, N1) :- number(N1), number(N2).

solveLinear(x=N2, y=N1, N2, N1) :- number(N1), number(N2).

solveLinear(y=RHS, x=N, N, Y) :-
	number(N),
	RHS=B*x+C,
	Y is B*N+C.

solveLinear(x=N, y=RHS, N, Y) :- 
	number(N),
	RHS=_*x+_,
	solveLinear(y=RHS, x=N, N, Y).