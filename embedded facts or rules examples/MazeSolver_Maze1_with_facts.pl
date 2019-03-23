/*******************************************************
 *   Executable example for the maze6 instance using   * 
 *     a list of facts approach instead of rules       *
 *******************************************************/

initial_state(  maze, p(1,1)  ).
final_state(  maze, p(13,13)  ).
c(0,0,wall).
c(0,1,wall).
c(0,2,wall).
c(0,3,wall).
c(0,4,wall).
c(0,5,wall).
c(0,6,wall).
c(0,7,wall).
c(0,8,wall).
c(0,9,wall).
c(0,10,wall).
c(0,11,wall).
c(0,12,wall).
c(0,13,wall).
c(0,14,wall).
c(1,0,wall).
c(1,2,wall).
c(1,6,wall).
c(1,10,wall).
c(1,14,wall).
c(2,0,wall).
c(2,2,wall).
c(2,4,wall).
c(2,6,wall).
c(2,8,wall).
c(2,10,wall).
c(2,12,wall).
c(2,14,wall).
c(3,0,wall).
c(3,2,wall).
c(3,4,wall).
c(3,6,wall).
c(3,8,wall).
c(3,10,wall).
c(3,11,wall).
c(3,12,wall).
c(3,14,wall).
c(4,0,wall).
c(4,2,wall).
c(4,4,wall).
c(4,8,wall).
c(4,10,wall).
c(4,14,wall).
c(5,0,wall).
c(5,2,wall).
c(5,4,wall).
c(5,5,wall).
c(5,6,wall).
c(5,7,wall).
c(5,8,wall).
c(5,10,wall).
c(5,11,wall).
c(5,12,wall).
c(5,14,wall).
c(6,0,wall).
c(6,2,wall).
c(6,6,wall).
c(6,8,wall).
c(6,10,wall).
c(6,12,wall).
c(6,14,wall).
c(7,0,wall).
c(7,2,wall).
c(7,4,wall).
c(7,6,wall).
c(7,8,wall).
c(7,10,wall).
c(7,12,wall).
c(7,14,wall).
c(8,0,wall).
c(8,2,wall).
c(8,4,wall).
c(8,6,wall).
c(8,8,wall).
c(8,10,wall).
c(8,12,wall).
c(8,14,wall).
c(9,0,wall).
c(9,2,wall).
c(9,4,wall).
c(9,6,wall).
c(9,8,wall).
c(9,14,wall).
c(10,0,wall).
c(10,2,wall).
c(10,4,wall).
c(10,6,wall).
c(10,8,wall).
c(10,9,wall).
c(10,10,wall).
c(10,11,wall).
c(10,12,wall).
c(10,14,wall).
c(11,0,wall).
c(11,2,wall).
c(11,4,wall).
c(11,6,wall).
c(11,14,wall).
c(12,0,wall).
c(12,2,wall).
c(12,3,wall).
c(12,4,wall).
c(12,6,wall).
c(12,7,wall).
c(12,8,wall).
c(12,9,wall).
c(12,10,wall).
c(12,11,wall).
c(12,12,wall).
c(12,14,wall).
c(13,0,wall).
c(13,12,wall).
c(13,14,wall).
c(14,0,wall).
c(14,1,wall).
c(14,2,wall).
c(14,3,wall).
c(14,4,wall).
c(14,5,wall).
c(14,6,wall).
c(14,7,wall).
c(14,8,wall).
c(14,9,wall).
c(14,10,wall).
c(14,11,wall).
c(14,12,wall).
c(14,13,wall).
c(14,14,wall).

	
/***************************************************************************/
/* Now we implement our table of moves.                                    */
/***************************************************************************/

move(  p( _, _ ), up    ).
move(  p( _, _ ), down  ).
move(  p( _, _ ), left  ).
move(  p( _, _ ), right ).
	
	

/***************************************************************************/
/* We now implement the state update functionality.                        */
/***************************************************************************/

% UP
update(  p(X, Y), up, p(X_new, Y)  ) :-
	X_new is X - 1.

% DOWN
update(  p(X,Y), down, p(X_new, Y) ) :-
	X_new is X + 1.

% LEFT
update(  p(X,Y), left, p(X, Y_new)  ) :-
	Y_new is Y - 1.

% RIGHT
update(  p(X,Y), right, p(X, Y_new)  ) :-
	Y_new is Y + 1.



/***************************************************************************/
/* Implementation of the predicate that checks whether a state is legal    */
/* according to the constraints imposed by the problem's statement.        */
/***************************************************************************/

legal(  p(X,Y) ) :-
	X >= 0,
    Y >= 0,
    \+ c(X,Y,wall).

/************************************************************************************/
/* A reusable depth-first problem solving framework.                                */
/************************************************************************************/

solve_dfs(Problem, State, _, []) :-
	final_state(Problem, State).
solve_dfs(Problem, State, History, [Move|Moves]) :-
	move(State, Move),
	update(State, Move, NewState),
	legal(NewState),
	\+ member(NewState, History),
    %print(NewState),
	solve_dfs(Problem, NewState, [NewState|History], Moves).

solve_problem(Problem, Solution) :-    
	initial_state(Problem, Initial),
	solve_dfs(Problem, Initial, [Initial], Solution).
	