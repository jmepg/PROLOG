/*Como fazer as jogadas:
	Pretas:
		Para colocar um anel -  placeBlackRing([lin,col]).
		Para colocar um disco - placeBlackDisk([lin,col]).
		Para mover um anel - moveBlackRing([lin,col]).
		Para mover um disco - moveBlackDisk([lin,col]).

	Brancas:
		Para colocar um anel -  placeWhiteRing([lin,col]).
		Para colocar um disco - placeWhiteDisk([lin,col]).
		Para mover um anel - moveWhiteRing([lin,col]).
		Para mover um disco - moveWhiteDisk([lin,col]).

*/

%Estrutura de dados: Lista 7*7 [[anel, disco],[anel,disco],...]

createBoard(B):- 
	B = [[[0,0], [0,0], [1,2], [0,0], [0,0], [0,0], [0,0]],
		  [[0,0], [0,0], [0,0], [3,2], [1,4], [0,0], [0,0]],
		  [[0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0]],
		  [[0,0], [0,0], [3,2], [1,0], [3,2], [0,0], [0,0]],
		  [[0,0], [0,0], [3,4], [3,4], [1,2], [3,0], [3,0]],
		  [[0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [1,0]],
		  [[0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0]]].	

displayBoard([]):-
	printHorizontalLine(29).

displayBoard([Line|B]):-
	displayLine(Line),
	displayBoard(B).
<<<<<<< HEAD

init:-createBoard(B),drawBoard(B,0).
=======
	
>>>>>>> b80aa223c53af4efb86916f86daa52bc68230b3c

getRing([Ring,Disk],Ring).

getDisk([Ring,Disk],Disk).

displayLine(Line):-
	printHorizontalLine(29),
	printRings(Line),
	printDisks(Line).

printRings([]):-
	printVerticalLine(1),
	nl.

printRings([Elem|Line]):-
	printVerticalLine(1),
	emptySpace(1),
	getRing(Elem,Ring),
	write(Ring),
	emptySpace(1),
	printRings(Line).

printDisks([]):-
	printVerticalLine(1),
	nl.

printDisks([Elem|Line]):-
	printVerticalLine(1),
	emptySpace(1),
	getDisk(Elem,Ring),
	write(Ring),
	emptySpace(1),
	printDisks(Line).

%imprime as linhas horizontais
printHorizontalLine(0):-
	nl.
printHorizontalLine(NumberOfDashes) :-
	write('-'),
	N is NumberOfDashes - 1,
	printHorizontalLine(N).

printVerticalLine(0).
printVerticalLine(Number):-
	write('|'),
	N is Number - 1,
	printVerticalLine(N).

drawL1(0).
drawL1(Number):-
	printVerticalLine(1),
	emptySpace(3),
	N1 is Number - 1,
	drawL1(N1).

drawL2(0).
drawL2(Number):-
	printVerticalLine(1),
	emptySpace(3),
	N1 is Number - 1,
	drawL2(N1).

drawBoard(0).
drawBoard(LineSquareNumber):-
	nl,
	printHorizontalLine(29),
	nl,
	drawL1(8),
	nl,
	drawL2(8),
	nl,
	printHorizontalLine(29),
	N1 is LineSquareNumber - 1,
	drawBoard(N1).

emptySpace(0).
emptySpace(NumberofSpaces):-
	write(' '),
	N1 is NumberofSpaces - 1,
	emptySpace(N1).


placeWhiteRing(_):-
	write('1'). 

placeWhiteDisk(_):-
	write('2').	

placeBlackRing(_):-
	write('3').

placeBlackDisk(_):-
	write('4').
	
drawBlank(0).
drawBlank(N):- write(' '),write(' '),N1 is N - 1, drawBlank(N1).


drawLine([]):-write('|').
drawLine([[Ring,Disk]|Rest]):-write('|'),write(Ring),write(','),write(Disk),drawLine(Rest).

	
drawTopLine(0):-write('/-\\').
drawTopLine(N):-write('/-\\_'), N1 is N - 1, drawTopLine(N1).
	
drawBoard([],N):-write(' '),drawBlank(N),drawTopLine(N).
	
drawBoard([Line|RestBoard],N):-
				drawBlank(N),write(' '),drawTopLine(6),
				nl,
				drawBlank(N),drawLine(Line),
				nl,
				N1 is N + 1,
				drawBoard(RestBoard,N1).
				