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
	B = [[[1,2], [1,2], [1,2], [1,2], [1,2], [1,2], [1,2]],
		  [[3,4], [0,4], [0,0], [3,\2], [1,4], [0,0], [0,0]],
		  [[3,4], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0]],
		  [[3,4], [0,4], [3,2], [1,0], [3,2], [0,0], [0,0]],
		  [[3,4], [0,4], [3,0], [3,4], [1,2], [3,0], [3,0]],
		  [[3,4], [0,0], [0,0], [0,0], [0,0], [0,0], [1,0]],
		  [[3,4], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0]]].	

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

play(Board, Player):-
	drawBoard(Board,0),
	((Player =:= 0,
	write('White'), write('Player: '), write(Player),nl,
	write('Place - 0, Move - 1'),nl, read(Ans),
	((Ans=:=0);(Ans=:=1)),
	((Ans =:= 0, placePawnAux(Board,Player,NewBoard));
	(Ans =:= 1, movePawnAux(Board,Player,NewBoard))),
	Player1 is 1);
	(Player =:= 1,
	write('Black'),write('Player: '), write(Player), nl,
	write('Place - 0, Move - 1'),nl, read(Ans),
	((Ans =:= 0, placePawnAux(Board,Player,NewBoard));
	(Ans =:= 1, movePawnAux(Board,Player,NewBoard))),
	Player1 is 0)),
	!, play(NewBoard,Player1).

play(Board,Player):- write('Invalid Input'),nl,nl,play(Board,Player),!.
	

placePawnAux(Board, Player, NewBoard):-
	write('PLACE A PAWM'),nl,
	write('Disk - 0 Ring - 1'),nl, read(Ans),
	write('X'), read(Xf),nl,
	write('Y'), read(Yf),nl,
	placePawn(Board,Player,Ans,Xf,Yf,NewBoard).


placePawn(Board,Player,Pawn,X,Y,NewBoard):-
	validPlay(Board, _, _, _,X,Y,0, _),
	((Pawn =:= 0, ((Player =:= 0, Disk is 2);
				(Player =:= 1, Disk is 4)),
	setDisk(Board,X,Y,Disk,NewBoard));
		(Pawn =:= 1, ((Player =:= 0, Ring is 1);
				(Player =:= 1, Ring is 3)),
	setRing(Board,X,Y,Ring,NewBoard))).

placePawn(Board,Player,_,_,_,NewBoard):- write('Invalid Play'),nl,nl, placePawnAux(Board,Player,NewBoard),!.

movePawnAux(Board,Player,NewBoard):-
	write('MOVE A PAWN'),nl,
	write('X'), read(X),nl,
	write('Y'), read(Y),nl,
	getRing(Board,X,Y,Ring), getDisk(Board,X,Y,Disk),
	write('RING: '), write(Ring), write('  Disk: '), write(Disk),nl,
	write('Disk - 0 Ring - 1'),nl, read(Ans),
	((Ans =:= 0, Player =:= 0, Disk =\= 2, write('ERROR'),nl,Test is 0); 
	(Ans =:= 0, Player =:= 1, Disk =\= 4,write('ERROR'),nl,Test is 0);
	(Ans =:= 1, Player =:= 0, Ring =\= 1,write('ERROR'),nl,Test is 0);
	(Ans =:= 1, Player =:= 1, Ring =\= 3,write('ERROR'),nl,Test is 0);
	(Ans =:= 0, Player =:= 0, Disk =:= 2, Pawn is 0, write('Move to:'),nl,write('Xf'), read(Xf),nl, write('Yf'), read(Yf),nl,Test is 1);
	(Ans =:= 0, Player =:= 1, Disk =:= 4, Pawn is 0, write('Move to:'),nl,write('Xf'), read(Xf),nl,write('Yf'), read(Yf),nl,Test is 1);
	(Ans =:= 1, Player =:= 0, Ring =:= 1, Pawn is 1, write('Move to:'),nl,write('Xf'), read(Xf),nl,write('Yf'), read(Yf),nl,Test is 1);
	(Ans =:= 1, Player =:= 1, Ring =:= 3, Pawn is 1, write('Move to:'),nl,write('Xf'), read(Xf),nl,write('Yf'), read(Yf),nl,Test is 1)),
	((Test =:= 0, !,movePawnAux(Board,Player, NewBoard));
	(Test=:=1, movePawn(Board,Player,X,Y,Xf,Yf,Pawn,NewBoard))).


movePawn(Board,Player,X,Y,Xf,Yf,Pawn,NewBoard2):-
	validPlay(Board,Player,X,Y,Xf,Yf,1,Pawn),
	((Player =:= 0,((Pawn =:= 0, setDisk(Board,X,Y,0,NewBoard), setDisk(NewBoard,Xf,Yf,2,NewBoard2));
					(Pawn =:= 1, setRing(Board,X,Y,0,NewBoard), setRing(NewBoard,Xf,Yf,1,NewBoard2))));
	(Player =:= 1, ((Pawn =:= 0, setDisk(Board,X,Y,0,NewBoard), setDisk(NewBoard,Xf,Yf,4,NewBoard2));
					(Pawn =:= 1, setRing(Board,X,Y,0,NewBoard), setRing(NewBoard,Xf,Yf,3,NewBoard2))))).

movePawn(Board,Player,_,_,_,_,_,NewBoard):- write('Invalid Play'),nl,nl, movePawnAux(Board,Player,NewBoard),!.

/*------------------------------------------------------------*/
%BLACK DISK

winBlackDisk(_,_,7,_):-write('BLACK WON'),nl,!.
winBlackDisk(Board,X,Y,Searched):-
	X<8,Y<8,
	getDisk(Board,X,Y,NewDisk), 
	NewDisk = 4, 
	findall([Xf,Yf],verifyAdjacent(X,Y,Xf,Yf),L),
	verifyBlackDiskExistence(Board,L,Searched).  
winBlackDisk(_,8,_,_):-fail,!.
winBlackDisk(Board,X,Y,Searched):-X<8,NextX is X+1, winBlackDisk(Board,NextX,Y,Searched),!.

verifyBlackDiskExistence(_,[],_,_):-!.
verifyBlackDiskExistence(Board,[L|_],Searched):-
	\+(member(L,Searched)),
	write(Searched),nl, write(L),nl,
	append(Searched,[L],NewSearched),
	nth0(0,L,X),nth0(1,L,Y),
	getDisk(Board,X,Y,NewDisk), NewDisk = 4,
	winBlackDisk(Board,X,Y,NewSearched),!.
verifyBlackDiskExistence(Board,[_|LTail], Searched):- verifyBlackDiskExistence(Board,LTail,Searched),!.
/*------------------------------------------------------------*/
%BLACK RING

winBlackRing(_,_,7,_):-write('BLACK WON'),nl,!.
winBlackRing(Board,X,Y,Searched):-
	X<8, Y<8,
	getRing(Board,X,Y,NewRing), 
	NewRing = 3, 
	findall([Xf,Yf],verifyAdjacent(X,Y,Xf,Yf),L),
	verifyBlackRingExistence(Board,L,Searched). 
winBlackRing(_,8,_,_):-fail,!.
winBlackRing(Board,X,Y,Searched):-X<8, NextX is X+1, winBlackRing(Board,NextX,Y,Searched),!.

verifyBlackRingExistence(_,[],_,_):-!.
verifyBlackRingExistence(Board,[L|_],Searched):-
	\+(member(L,Searched)),
	write(Searched),nl, write(L),nl,
	append(Searched,[L],NewSearched),
	nth0(0,L,X),nth0(1,L,Y),
	getRing(Board,X,Y,NewRing), NewRing = 3,
	winBlackRing(Board,X,Y,NewSearched),!.
verifyBlackRingExistence(Board,[_|LTail], Searched):- verifyBlackRingExistence(Board,LTail,Searched),!.
/*-----------------------------------------------------------------------------------*/
%White DISK

winWhiteDisk(_,7,_,_):-write('White WON'),nl,!.
winWhiteDisk(Board,X,Y,Searched):-
	X<8, Y<8,
	getDisk(Board,X,Y,NewDisk), 
	NewDisk = 2,
	write('DISK'),nl, 
	findall([Xf,Yf],verifyAdjacent(X,Y,Xf,Yf),L),
	verifyWhiteDiskExistence(Board,L,Searched).  
winWhiteDisk(_,_,8,_):-fail,!.
winWhiteDisk(Board,X,Y,Searched):-Y<8,NextY is Y+1, winWhiteDisk(Board,X,NextY,Searched),!.

verifyWhiteDiskExistence(_,[],_,_):-!.
verifyWhiteDiskExistence(Board,[L|_],Searched):-
	\+(member(L,Searched)),
	write(Searched),nl, write(L),nl,
	append(Searched,[L],NewSearched),
	nth0(0,L,X),nth0(1,L,Y),
	getDisk(Board,X,Y,NewDisk), NewDisk = 2,
	winWhiteDisk(Board,X,Y,NewSearched),!.
verifyWhiteDiskExistence(Board,[_|LTail], Searched):- verifyWhiteDiskExistence(Board,LTail,Searched),!.

/*------------------------------------------------------------------------------*/
%WHITE RING
%BLACK RING

winWhiteRing(_,7,_,_):-write('White WON'),nl,!.
winWhiteRing(Board,X,Y,Searched):-
	X<8, Y<8,
	getRing(Board,X,Y,NewRing), 
	NewRing = 1, 
	findall([Xf,Yf],verifyAdjacent(X,Y,Xf,Yf),L),
	verifyWhiteRingExistence(Board,L,Searched). 
winWhiteRing(_,_,8,_):-fail,!.
winWhiteRing(Board,X,Y,Searched):-Y<8,NextY is Y+1, winWhiteRing(Board,X,NextY,Searched),!.

verifyWhiteRingExistence(_,[],_,_):-!.
verifyWhiteRingExistence(Board,[L|_],Searched):-
	\+(member(L,Searched)),
	write(Searched),nl, write(L),nl,
	append(Searched,[L],NewSearched),
	nth0(0,L,X),nth0(1,L,Y),
	getRing(Board,X,Y,NewRing), NewRing = 1,
	winWhiteRing(Board,X,Y,NewSearched),!.
verifyWhiteRingExistence(Board,[_|LTail], Searched):- verifyWhiteRingExistence(Board,LTail,Searched),!.