:- source_location(FilePath, _),
   file_directory_name(FilePath, Dir),
   directory_file_path(Dir, 'basic_xy_algebra.prolog', AlgebraPath),
   consult(AlgebraPath).

range(Low, High, []) :-
    Low > High.
range(Low, High, [Low|Rest]) :-
    Low =< High,
    NextLow is Low + 1,
    range(NextLow, High, Rest).

:- dynamic red_tile/3.

assertz_red_tiles(Columns, Rows, IdStart) :-
    ground(IdStart),
    length(Columns, Len_Must_Equal),
    length(Rows, Len_Must_Equal),
    High is IdStart + Len_Must_Equal - 1,
    range(IdStart, High, Range),

    forall(
        ( nth0(Enumerate, Range, Id), 
	  nth0(Enumerate, Columns, C), 
	  nth0(Enumerate, Rows, R) 
	),
        assertz(red_tile(Id, C, R))
    ).

assertz_red_tiles(Columns, Rows) :- assertz_red_tiles(Columns, Rows, 0).

inclusive_count(Start, End, Result) :-
	Result is abs(End - Start) + 1.

red_tile_diff(Id1, Id2, C, R) :-
	red_tile(Id1,C1,R1),
	red_tile(Id2,C2,R2),
	inclusive_count(C1,C2,C),
	inclusive_count(R1,R2,R).

% tile_diff(VirtualTile1, VirtualTile2, C, R) :-
%	VirtualTile1 = virtual_tile(C1,R1),
%	VirtualTile2 = virtual_tile(C2,R2),
%	inclusive_count(C1,C2,C),
%	inclusive_count(R1,R2,R).

% to_virtual(Id,Result) :-
%	tile(Id,C,R),
%	Result = virtual_tile(C,R).

rectangle_red_tile(Id1, Id2, Area) :-
	red_tile(Id1,_,_),
	red_tile(Id2,_,_),
	red_tile_diff(Id1,Id2,C,R),
	Area is abs(C) * abs(R).

rectangle_red_tile(Pair, Area) :-
	Pair = [Id1,Id2],
	rectangle_red_tile(Id1, Id2, Area).

% list_of_lists_lengths([], []).
% list_of_lists_lengths([H|T], [HLen|TLens]) :-
%	length(H, HLen),
%	list_of_lists_lengths(T, TLens).

matchUpPair(List, Left, Right) :-
	append(_, [Left|Rest], List),
	member(Right, Rest).

roundRobin(List, Pairings) :-
	sort(List, Sorted),
	findall([Left, Right], matchUpPair(Sorted, Left, Right), Pairings).

part_1_solution(Id1, Id2, Max) :- 
	findall(Id, red_tile(Id,_,_), RedTiles), 
	roundRobin(RedTiles, Pairings), 
	findall(Area, 
		(member(Pair, Pairings), 
		 rectangle_red_tile(Pair, Area)
		), 
	Areas
	), 
	max_member(Max, Areas), 
	nth0(Index, Areas, Max), 
	nth0(Index, Pairings, MaxPair),
	[Id1, Id2] = MaxPair.

tile(red, Id, C, R) :- red_tile(Id, C, R).

% add_to_all([Num], Addition, [Sum]) :-
%	ground(Num),
%	ground(Addition),
%	Sum is Num + Addition.

% add_to_all([H|T], Addition, [Sum|Rest]) :-
%	ground([H|T]),
%	ground(Addition),
%	Sum is H + Addition,
%	add_to_all(T, Addition, Rest).
	
cycleShift(List, 0, List).
cycleShift([H|T], 1, NewList) :- append(T,[H],NewList).	
cycleShift([H|T], N, NewList) :- 
	ground(N),
	N > 1,
	cycleShift([H|T], 1, NextList),
	NextN is N - 1,
	cycleShift(NextList, NextN, NewList).

cycleShift(List, N, NewList) :-
	ground(N),
	N < 0,
	PosN is abs(N),
	cycleShift(NewList, PosN, List).

:- dynamic tile_connected/3.

assertCyclicalConnections(ConnectionColor, ListOfIds) :-
	ground(ConnectionColor),
	sort(ListOfIds, Sorted),
	cycleShift(Sorted, 1, Shifted),
	forall(
		(nth0(Index, Sorted, Left),
		 nth0(Index, Shifted, Right)),
		assertz(tile_connected(ConnectionColor, Left, Right))
	).

red_tile_connected(Id1,Id2) :- tile_connected(red, Id1, Id2).

hline(_,R,_,R).

vline(C,_,C,_).

orthLine(C,R,C,R).
orthLine(C1,R1,C2,R2) :- 
	hline(C1,R1,C2,R2) ;
	vline(C1,R1,C2,R2).
    
inside(Left, Right, X) :-
    between(Left, Right, X),
    X \= Left,
    X \= Right.

example_tiles :- 
    Columns = [7,11,11,9,9,2,2,7], 
    Rows = [1,1,7,7,5,5,3,3],
	assertz_red_tiles(
        Columns,
		Rows,
        0
    ),
    length(Columns, Length),
    High is Length - 1,
    range(0, High, ListOfIds),
    assertCyclicalConnections(red, ListOfIds).
    
clear_red_tiles :- 
    retractall(red_tile(_,_,_)),
    retractall(tile_connected(red, _, _)).
    
 tile_color_spatial(C, R, Color) :-
	tile(Color, _, C, R). 
   
 borderType(Id1, Id2, Type) :-
    ground(Id1),
    ground(Id2),
    once((
        tile_connected(red, Id1, Id2),
        Id1 \= Id2,
        ( (tile(red, Id1, C, _), tile(red, Id2, C, _)) -> Type = 'Column' ;
          (tile(red, Id1, _, R), tile(red, Id2, _, R)) -> Type = 'Row' 
        )
    )).
    
 border(Id1, Id2, [[C,C], [R1,R2]]) :-
    ground(Id1),
    ground(Id2),
    borderType(Id1, Id2, 'Column'),
    tile(red, Id1, C, R1),
    tile(red, Id2, C, R2).
    
 border(Id1, Id2, [[C1,C2], [R,R]]) :-
    ground(Id1),
    ground(Id2),
    borderType(Id1, Id2, 'Row'),
    tile(red, Id1, C1, R),
    tile(red, Id2, C2, R).

line_segment([CWest, _], [CEast, _]) :-
    CWest =< CEast.

to_line_segment([C1,R1], 
		[C2,R2], 
		LineSegment
		) :-
     ground([[C1,R1], [C2,R2]]),
    (
     (line_segment([C1,R1], [C2,R2])) -> (LineSegment = line_segment([C1,R1], [C2,R2])) ;
     (line_segment([C2,R2], [C1,R1])) -> (LineSegment = line_segment([C2,R2], [C1,R1]))
    ).

magnitude(LineSegment, Mag) :-
    line_segment([Cw,Rw],[Ce,Re]) = LineSegment,
    Mag is sqrt(((Ce - Cw) ^ 2) + ((Re - Rw) ^ 2)).

infinite_line(LineSegment, Precision) :-
    ground(Precision),
    magnitude(LineSegment, Mag),
    Error is abs(1 - Mag),
    Error < Precision.

infinite_line(LineSegment, Precision) :-
    var(Precision),
    magnitude(LineSegment, Mag),
    Precision is abs(1 - Mag).

to_infinite_line(LineSegment, 
		 infinite_line(line_segment([Cwu,Rwu],[Ceu,Reu]),
			       Error
				)
		) :-
   ground(LineSegment),
   line_segment([Cw,Rw],[Ce,Re]) = LineSegment,
   magnitude(LineSegment, Mag),
   Cwu is Cw / Mag,
   Ceu is Ce / Mag,
   Rwu is Rw / Mag,
   Reu is Re / Mag,
   infinite_line(line_segment([Cwu,Rwu],[Ceu,Reu]),
			       Error
				).

to_infinite_line(LineSegment, 
		 ILine
		) :-
   ground(ILine),
   ILine = infinite_line(LineSegment, _).

gradient(LineSegment, Grad) :-
    ground(LineSegment),
    line_segment([Cw,Rw],[Ce,Re]) = LineSegment,
    Rise is Ce - Cw,
    Run is Re - Rw,
    Run =\= 0.0,
    Grad is Rise / Run.

gradient(ILine, Grad) :-
    ground(ILine),
    to_infinite_line(LineSegment, 
		 ILine
		),
    gradient(LineSegment, Grad).
    

to_formula(infinite_line(LineSegment, _), Formula, (neginf<x)<inf, (neginf<y)<inf) :-
   ground(LineSegment),
   gradient(LineSegment, B),
   B =\= 0.0,
   NegB is 0 - B,
   line_segment([X,NegY],_) = LineSegment,
   Const is (0 - NegY) - (B*X),
   NegConst is 0 - Const,
   Formula = '='(y,'+'('*'(NegB,x),NegConst)).

to_formula(infinite_line(LineSegment, _), Formula, (neginf<x)<inf, (neginf<y)<inf) :-
   ground(LineSegment),
   gradient(LineSegment, B),
   B =:= 0.0,
   line_segment([_,NegY],_) = LineSegment,
   Const is (0 - NegY),
   NegConst is 0 - Const,
   Formula = '='(y,NegConst).

to_formula(infinite_line(line_segment([0,R],[1,R]),_), '='(x,R), (R=<x)=<R, (neginf<y)<inf) :-
   ground(R).

to_formula(ILine, '='(x,R), (R=<x)=<R, (neginf<y)<inf) :-
   ground(ILine),
   ILine = infinite_line(line_segment([_,R],[_,R]),_).

to_formula(ILine, '='(y,'+'('*'(NegB,x),NegConst)), (neginf<x)<inf, (neginf<y)<inf) :-
   ground([NegB, NegConst]),
   Cw is 0 - NegConst,
   Re is 0 - NegB,
   LineSegment =line_segment([Cw, 0],[1, Re]),
   to_infinite_line(LineSegment, 
		 ILine
		).

to_formula(LineSeg, ILFormula, ConstraintX, ConstraintY) :-
   ground(LineSeg),
   LineSeg = line_segment([Cw,Rw], [Ce,Re]),
   to_infinite_line(LineSeg, ILine),
   to_formula(ILine, ILFormula, _, _),
   ConstraintX = ((Cw=<x)=<Ce),
   ConstraintY = ((Re=<y)=<Rw).
   
connectionToLineSegment(Id1, Id2, LineSegment) :-
   tile_connected(Color, Id1, Id2),
   tile(Color, Id1, C1, R1),
   tile(Color, Id2, C2, R2),
   to_line_segment([C1,R1],[C2,R2], LineSegment).

allConnections(Color, Sorted) :-
   findall([Id1, Id2], tile_connected(Color, Id1, Id2), List),
   sort(List, Sorted).

connection(Color, Conn) :-
   allConnections(Color, Sorted),
   member(Conn, Sorted).
