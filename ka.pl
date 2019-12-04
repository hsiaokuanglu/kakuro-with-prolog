/*
problem 1
	0 7 3
	4 3 1
	6 4 2
*/
problem(Id, N, Hint, Blanks) :-
	Id = 1,
	N = 3,
	Hint = [
		[7, [1,1], [2,1]],
		[3, [1,2], [2,2]],
		[4, [1,1], [1,2]],
		[6, [2,1], [2,2]]
	],
	Blanks = [
		[0,0], [0,1], [0,2],
		[1,0],
		[2,0]
	].
/*
problem 2
	0  6  7 12
	6  1  2  3
	7  2  1  4
	12 3  4  5
*/
problem(Id, N, Hint, Blanks) :-
	Id = 2,
	N = 4,
	Hint = [
		[6, [1,1], [2,1], [3,1]],
		[7, [1,2], [2,2], [3,2]],
		[12,[1,3], [2,3], [3,3]],
		[6, [1,1], [1,2], [1,3]],
		[7, [2,1], [2,2], [2,3]],
		[12,[3,1], [3,2], [3,3]]
	],
	Blanks = [
		[0,0], [0,1], [0,2], [0,3],
		[1,0],
		[2,0],
		[3,0]
	].
/*
problem 3
	0 13 11
	7  5  2
	17 8  9

	*or*
	
	0 13 11
	7  4  3
	17 9  8
*/
problem(Id, N, Hint, Blanks) :-
	Id = 3,
	N = 3,
	Hint = [
		[13, [1,1], [2,1]],
		[11, [1,2], [2,2]],
		[7, [1,1], [1,2]],
		[17, [2,1], [2,2]]
	],
	Blanks = [
		[0,0], [0,1], [0,2],
		[1,0],
		[2,0]
	].
/*
	0 0 0
	0 0 1
	0 2 3
*/
problem(Id, N, Hint, Blanks) :-
	Id = 4,
	N = 3,
	Hint = [
		[2, [2,1]],
		[4, [1,2], [2,2]],
		[1, [1,2]],
		[5, [2,1], [2,2]]
	],
	Blanks = [
		[0,0], [0,1], [0,2],
		[1,0], [1,1],
		[2,0]
	].
/*
problem 5
	0  0  0  0
	0  0  2  0
	0  0  1  4
	0  3  4  0
*/
problem(Id, N, Hint, Blanks) :-
	Id = 5,
	N = 4,
	Hint = [
		
		[7, [1,2], [2,2], [3,2]],
		
		[2, [1,2]],
		[5, [2,2], [2,3]],
		[7, [3,1], [3,2]]
	],
	Blanks = [
		[0,0], [0,1], [0,2], [0,3],
		[1,0], [1,1],        [1,3],
		[2,0], [2,1],
		[3,0],			     [3,3]
	].
% try go(1).
go(P) :- problem(P, N, H, B), blanks(X, N, B), lines2(X, H), print1(X).



% has_width(W, X) is true if matrix X has width W
has_width(W, [L]) :-
	length(L, W).
has_width(W, [[H|T2]|T]) :-
	length([H|T2], W),
	has_width(W, T).

% has_height(W, L) is true if list X has height W
has_height(H, L) :-
	length(L, H).

% print1(X) prints the matrix X
print1([H|T]) :-
	writeln(H),
	print1(T).
print1([]).

% set_matrixIJ(X, I, J, V) is true if the position (I,J) of matrix X has the value V
set_matrixIJ(X, I, J, V) :-
	nth0(I, X, Line),
	nth0(J, Line, V).

% blanks(X, N, Blanks) is true when matrix X with dimensions NxN has 0 at postions in the list Blanks
blanks(_, _, []).
blanks(X, N, [Blank|T]) :-
	has_height(N, X),
	has_width(N,X),
	matrix_alldigit(X),
	[I,J] = Blank,
	set_matrixIJ(X, I, J, 0),
	blanks(X, N, T).

% lines2(X, Hints) is true when a solution is found using kakuro rules
lines2(_, []).
lines2(X, [Hint|T]) :-
	[Sum|Pos] = Hint,
	length(Pos, G),
	length(Line, G),
	kakuro(Line, Sum),
	find_line(Pos, X, Line),
	lines2(X, T).

% find_line(Pos, X, Line) is true when Line(list of numbers) has the numbers specified by Pos(a list of positions) in X(matrix)
find_line([[I,J]|T1], X, [H|T2]) :-
	set_matrixIJ(X,I,J,H),
	find_line(T1, X, T2).
find_line([], _, []).

% matrix_alldigit(X) is true when all numbers in X are members of 0-9
matrix_alldigit(X) :-
	all_dig_I(X).
all_dig_I([H|T]) :-
	alldigits2(H),
	all_dig_I(T).
all_dig_I([]).

% helper for matrix_alldigit
alldigits2([]).
alldigits2([X|Y]) :- digit2(X), alldigits2(Y).
digit2(X) :- member(X, [0,1,2,3,4,5,6,7,8,9]).

% ----------------------------------
% kakuro(L,S) is true if digits in L are in the set {1,...,9},
%                        all digits are unique)
%                        all digits in L add up to S
kakuro(L,S) :- alldigits(L), alldifferent(L), listsum(L,S).

% true if all digits are within the set {1,...,9}
alldigits([]).
alldigits([X|Y]) :- digit1(X), alldigits(Y).

% helper for alldigits
digit1(X) :- member(X,[1,2,3,4,5,6,7,8,9]).

% true if all digits are unique
alldifferent([]).
alldifferent([X|Y]) :- alldifferent(Y), notmember(X,Y).

% helper for alldifferent
notmember(X, Y) :- \+member(X, Y).

% true if all digits in list add up to S
listsum([],0).
listsum([X|Y],S) :- listsum(Y,S1), S is S1 + X.

% --------
% constants for testing
% [[A,B],[C,D]]