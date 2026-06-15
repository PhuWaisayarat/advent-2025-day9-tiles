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