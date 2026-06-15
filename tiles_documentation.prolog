doc_topic(Topic) :- 
	member(Topic, 
		[doc_topic, 
		 documentation,
		 red_tile,
		 inclusive_count,
		 red_tile_diff,
		 rectangle_red_tile,
		 assertz_red_tiles,
		 range,
		 matchUpPair,
		 roundRobin,
		 part_1_solution,
		 clear_red_tiles,
		 example_tiles,
		 % add_to_all
		]
	).

documentation(doc_topic) :-
    writeln('%!  doc_topic(+Topic:atom) is semidet.'),
    writeln('%'),
    writeln('%   Succeeds if Topic exists in the database.'),
    writeln('%   Avoids printing documentation unlike documentation.').

documentation(documentation) :-
    writeln('%!  documentation(+Topic:atom) is semidet.'),
    writeln('%'),
    writeln('%   Succeeds if Topic exists in the database.'),
    writeln('%   Prints PlDoc-style documentation for the given predicate to the stdout.').

documentation(red_tile) :-
    writeln('%!  red_tile(?Id, ?Column, ?Row) is nondet.'),
    writeln('%'),
    writeln('%   Succeeds if red tile of Id exists at Column and Row in database'),
    writeln('%   Representation of a red tile in the puzzle,'),
    writeln('%   the Id is intended for backtracking and lookup.').

documentation(inclusive_count) :-
    writeln('%!  inclusive_count(+Start:int, +End:int, -Result) is det.'),
    writeln('%'),
    writeln('%   Instantiate Result to the inclusive count, AKA:'),
    writeln('%       Start + End + 1').

documentation(red_tile_diff) :-
    writeln('%!  tile_diff(+Id1, +Id2, -C, -R) is nondet.'),
    writeln('%'),
    writeln('%   Search for given red tiles with Id1 and Id2 in the database.'),
    writeln('%   Instantiate C and R to the inclusive count between their columns and rows,'),
    writeln('%   respectively.').

% documentation(to_virtual) :-
%    writeln('%!  to_virtual(?Id, -Result:virtual_tile) is nondet.'),
%    writeln('%'),
%    writeln('%   Succeeds if Result unifies to virtual_tile(C,R)'),
%    writeln('%   and tile(Id,C,R) exists in the database.').

documentation(rectangle_red_tile) :-
    writeln('%!  rectangle_red_tile(?Id1, ?Id2, -Area:number) is nondet.'),
    writeln('%!  rectangle_red_tile(?Pair:list, -Area:number) is nondet.'),
    writeln('%'),
    writeln('%   True if Area is the absolute grid area bounded by the'),
    writeln('%   red tiles with Id1 and Id2.'),
    writeln('%   rectangle_existing/3 uses discrete IDs,'),
    writeln('%   rectangle_existing/2 uses a list with exactly 2 atoms.').

documentation(assertz_red_tiles) :-
    writeln('%!  assertz_red_tiles(+Columns:list, +Rows:list, +IdStart:int) is semidet.'),
    writeln('%!  assertz_red_tiles(+Columns:list, +Rows:list) is semidet.'),
    writeln('%'),
    writeln('%   Assert red tiles from lists Columns and Rows'),
    writeln('%.  similar to Python\'s zip, but strictly needs lists to be equal'),
    writeln('%   length, otherwise it will fail.'),
    writeln('%   The red tile Ids start at IdStart and are enumerated sequentially,'),
    writeln('%   and assertz_red_tiles/2 defaults the IdStart to 0.'),
    writeln('%   This predicate should be faster than asserting each red tile through'),
    writeln('%   individual queries from Python.'),
    writeln('%'),
    writeln('%   @warning This may create duplicated red tile Ids in the database'),
    writeln('%   if Ids are misaligned, or tiles aren\'t properly cleaned up.').

documentation(range) :-
    writeln('%!  range(+Low:int, +High:int, -List:list) is det.'),
    writeln('%'),
    writeln('%   Succeeds if List is an ordered list of integers from Low to High,'),
    writeln('%   inclusive,'),
    writeln('%   or List is an empty list if Low is greater than High.').

% documentation(list_of_lists_lengths) :-
%   writeln('%!  list_of_lists_lengths(+ListOfLists:list, -Lengths:list) is det.'),
%   writeln('%'),
%   writeln('%   Succeeds if Lengths is an ordered list of the lengths of'),
%   writeln('%   each sublist within ListOfLists.').

documentation(matchUpPair) :-
    writeln('%!  matchUpPair(+List:list, -Left, -Right) is nondet.'),
    writeln('%'),
    writeln('%   Succeeds if Left and Right are atoms from List such that Left'),
    writeln('%   appears before Right in the list sequence.'),
    writeln('%   This is a generator for unique unordered pairings.').

documentation(roundRobin) :-
    writeln('%!  roundRobin(+List:list, -Pairings:list) is det.'),
    writeln('%'),
    writeln('%.  Succeeds if Pairings is a list of two-atom sublists,'),
    writeln('%   where each pair of atom from the set of atoms in the List is paired once,'),
    writeln('%   ignoring order.').

documentation(part_1_solution) :-
    writeln('%!  existing_max_area(?Id1, ?Id2, ?Max:int) is semidet.'),
    writeln('%'),
    writeln('%   Fails if there are fewer than two red tiles in the runtime/KB.'),
    writeln('%   Succeeds if the red tiles Id1 and Id2 form the'),
    writeln('%   biggest rectangle as per the puzzle, out of all existing runtime/KB tiles.').

documentation(clear_red_tiles) :-
    writeln('%!  clear_red_tiles is det.'),
    writeln('%   Equivalent to retractall(red_tile(_,_,_)).').

documentation(example_tiles) :-
    writeln('%!  example_tiles is det.'),
    writeln('%   Equivalent to assertz_red_tiles([7,11,11,9,9,2,2,7], [1,1,7,7,5,5,3,3]).'),
    writeln('%   Assert example red tiles for debugging.').

% documentation(add_to_all) :-
%    writeln('%!  add_to_all(+List, +Addition:int, ?Result) is semidet.'),
%    writeln('%   Succeeds if each element in Result is'),
%    writeln('%   the elements in List with Addition added on.').

documentation(cycleShift) :-
    writeln('%!  cycleShift(?List, +N:int, ?ShiftedList) is semidet.'),
    writeln('%   Succeeds if ShiftedList is List shifted N times to the left,'),
    writeln('%   with a cyclic structure (the first item is moved to the back per shift).'),
    writeln('%'),
    writeln('%   If N is negative, shift N times to the right.').