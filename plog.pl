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

:- use_module(library(lists)).

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
	
init(X,Y,Ring):-createBoard(B),drawBoard(B,0),getRing(B,X,Y,Ring).
	

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
	
	%Drawing of board
	
drawBlank(0).
drawBlank(N):- write(' '),write(' '),N1 is N - 1, drawBlank(N1).


drawLine([]):-write('|').
drawLine([[Ring,Disk]|Rest]):-write('|'),write(Ring),write(','),write(Disk),drawLine(Rest).

	
drawTopLine(0):-write('/ \\').
drawTopLine(N):-write('/ \\ '), N1 is N - 1, drawTopLine(N1).

drawBotLine(0):-write('\\').
drawBotLine(N):-write('\\_/ '), N1 is N - 1, drawBotLine(N1).

	
drawBoard([],N):-drawBlank(N),drawBotLine(7),nl.
	
drawBoard([Line|RestBoard],N):-drawBlank(N),drawBotLine(7),nl,
				write(' '),drawBlank(N),drawLine(Line),
				nl,
				N1 is N + 1,
				drawBoard(RestBoard,N1).
				
%Movements
	

getElem(Board,X,Y,Elem):-nth1(Y,Board,Line),nth1(X,Line,Elem).

getRing(Board,X,Y,Ring):-getElem(Board,X,Y,[Ring,_]).

getDisk(Board,X,Y,Disk):-getElem(Board,X,Y,[_,Disk]).


				