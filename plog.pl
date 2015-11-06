/* Como fazer as jogadas:
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
:- use_module(library(between)).

/* Estrutura de dados: Lista 7*7 [[anel, disco],[anel,disco],...] */

createBoard(B):- 
	B = [[[0,0], [0,0], [1,0], [0,0], [0,0], [0,0], [0,0]],
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

/* init function */
init(X,Y,Ring,Disk):-createBoard(B),drawBoard(B,0),setRing(B,X,Y,Ring,NewB),setDisk(NewB,X,Y,Disk,NewB2),drawBoard(NewB2,0).
	

getRing([Ring,_],Ring).

getDisk([_,Disk],Disk).

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

/* imprime as linhas horizontais*/
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
	
	
/*	Drawing of board 	*/
	
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
				drawBoard(RestBoard,N1),!.
				
/*	Movements	*/
	
/*	aux		*/


%Atribui um valor ao disco indicado por X e Y
setDisk(Board,X,Y,Disk,NewBoard):- getRing(Board,X,Y,Ring),setMatrix(Board,X,Y,[Ring,Disk],NewBoard).

setRing(Board,X,Y,Ring,NewBoard):- getDisk(Board,X,Y,Disk), setMatrix(Board,X,Y,[Ring,Disk],NewBoard).

setMatrix(Matrix,X,Y,Elem,NewMatrix):-getListFromMatrix(Matrix,Y,List), setList(List,X,Elem,NewList), setList(Matrix,Y,NewList,NewMatrix).

getListFromMatrix(Matrix,N,List):-nth1(N,Matrix,List).

setList([_|Rest],1,NewElem,[NewElem|Rest]):-!.

setList([H|Rest],N,NewElem,[H|NewRest]):- N1 is N - 1,setList(Rest,N1,NewElem,NewRest).
	
getElem(Board,X,Y,Elem):-nth1(Y,Board,Line),nth1(X,Line,Elem).

getRing(Board,X,Y,Ring):-getElem(Board,X,Y,[Ring,_]).

getDisk(Board,X,Y,Disk):-getElem(Board,X,Y,[_,Disk]).

verifyEmpty([Ring,Disk]):-(Ring =:= 0, Disk =:= 0). 

verifyAdjacent(X,Y,Xf,Yf):- Y1  is Y - 1,Y2 is Y + 1, between(Y1,Y2,YIndex),YIndex>0,YIndex<8,Yf is YIndex,(
							(YIndex =:= Y1,XF is X + 1,(Xf is X;(XF < 8,Xf is XF)));
							(YIndex =:= Y,XF1 is X - 1, XF2 is X + 1,((XF1 > 0, Xf is XF1);(XF1 <8,Xf is XF2)));
							(YIndex =:= Y2,XF is X - 1,(Xf is X;(XF > 0,Xf is XF)))
							).
%Mode : 0 - Putting a piece
%Mode : 1 - Moving a piece
%Pawn : 0 - disk 
%Pawn : 1 - ring 


validPlay(Board,Player,X,Y,Xf,Yf,Mode,Pawn):-
	getElem(Board,Xf,Yf,Elem),
	((Mode =:= 0,
		verifyEmpty(Elem));
	(Mode =:= 1,
		verifyAdjacent(X,Y,Xf,Yf),
		((Pawn =:= 1, Player =:= 0, getRing(Board,X,Y,Ring),getRing(Board,Xf,Yf,NewRing),Ring =:= 1, NewRing =:= 0);
		(Pawn =:= 0, Player =:= 0, getDisk(Board,X,Y,Disk),getDisk(Board,Xf,Yf,NewDisk),Disk =:= 2, NewDisk =:= 0);
		(Pawn =:= 1, Player =:= 1, getRing(Board,X,Y,Ring),getRing(Board,Xf,Yf,NewRing),Ring =:= 3, NewRing =:= 0);
		(Pawn =:= 0, Player =:= 1, getDisk(Board,X,Y,Disk),getDisk(Board,Xf,Yf,NewDisk),Disk =:= 4, NewDisk =:= 0)))).

play(Board):-
	write('White'),nl,
	write('Place - 0, Move - 1'),nl, read(Ans),
	((Ans =:= 0, placePawn(Board,0));
	(Ans =:= 1, movePawn(Board,0))).




placePawn(Board, Player):-
	write('PLACE A PAWM'),nl,
	write('Disk - 0 Ring - 1'),nl, read(Ans),
	write('X'), read(X),nl,
	write('Y'), read(Y),nl,
	Pawn is 0, Mode is 0, Xf is 0, Yf is 0, 
	validPlay(Board,Player,X,Y,Xf,Yf,Mode,Pawn),
	((Ans =:= 0, ((Player =:= 0, Disk is 2);
				(Player =:= 1, Disk is 4)),
	setDisk(Board,X,Y,Disk,NewBoard));
		(Ans =:= 1, ((Player =:= 0, Ring is 1);
				(Player =:= 1, Ring is 3)),
	setRing(Board,X,Y,Ring,NewBoard))),
	drawBoard(NewBoard,0).

movePawn(Board,Player):-
	write('MOVE A PAWM'),nl,
	write('X'), read(X),nl,
	write('Y'), read(Y),nl,
	getRing(Board,X,Y,Ring), getDisk(Board,X,Y,Disk),
	write('Disk - 0 Ring - 1'),nl, read(Ans),
	write('RING'), write(Ring), write('Disk'), write(Disk),
	((Ans =:= 0, Player =:= 0, Disk =\= 2, write('ERROR'),nl, movePawn(Board,Player)); %Os erros estao a funcionar
	(Ans =:= 0, Player =:= 1, Disk =\= 4,write('ERROR'),nl, movePawn(Board,Player));
	(Ans =:= 1, Player =:= 0, Ring =\= 1,write('ERROR'),nl, movePawn(Board,Player));
	(Ans =:= 1, Player =:= 1, Ring =\= 3,write('ERROR'),nl, movePawn(Board,Player)),
	(Ans =:= 0, Player =:= 0, Disk =:= 2, Pawn is 0, write('Move to:'),nl,write('Xf'), read(Xf),nl,
	write('Yf'), read(Yf),nl);
	(Ans =:= 0, Player =:= 1, Disk =:= 4, Pawn is 0, write('Move to:'),nl,write('Xf'), read(Xf),nl,
	write('Yf'), read(Yf),nl);
	(Ans =:= 1, Player =:= 0, Ring =:= 1, Pawn is 1, write('Move to:'),nl,write('Xf'), read(Xf),nl,
	write('Yf'), read(Yf),nl);
	(Ans =:= 1, Player =:= 1, Ring =:=3, Pawn is 1, write('Move to:'),nl,write('Xf'), read(Xf),nl,
	write('Yf'), read(Yf),nl)),
	Mode is 1,
	validPlay(Board,Player,X,Y,Xf,Yf,Mode,Pawn),
	move(Board,Player,X,Y,Xf,Yf,Pawn).



move(Board,Player,X,Y,Xf,Yf,Pawn):-
	((Player =:= 0,(Pawn =:= 0, setDisk(Board,X,Y,0,NewBoard), setDisk(NewBoard,Xf,Yf,2,NewBoard2));
					(Pawn =:= 1, setRing(Board,X,Y,0,NewBoard), setRing(NewBoard,Xf,Yf,1,NewBoard2)));
	(Player =:= 1, (Pawn =:= 0, setDisk(Board,X,Y,0,NewBoard), setDisk(NewBoard,Xf,Yf,4,NewBoard2));
					(Pawn =:= 1, setRing(Board,X,Y,0,NewBoard), setRing(NewBoard,Xf,Yf,3,NewBoard2)))),
	drawBoard(NewBoard2,0).


	


