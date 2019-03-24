/*******************************************************
 *   Executable example for the maze1 instance using   * 
 *    the rule approach instead of a list of facts     *
 *******************************************************/

initial_state(  maze, p(1,1)  ).
final_state(  maze, p(13,13)  ).
c(X, Y, wall) :-
	X = 0, Y = 0
	;
	X = 0, Y = 1
	;
	X = 0, Y = 2
	;
	X = 0, Y = 3
	;
	X = 0, Y = 4
	;
	X = 0, Y = 5
	;
	X = 0, Y = 6
	;
	X = 0, Y = 7
	;
	X = 0, Y = 8
	;
	X = 0, Y = 9
	;
	X = 0, Y = 10
	;
	X = 0, Y = 11
	;
	X = 0, Y = 12
	;
	X = 0, Y = 13
	;
	X = 0, Y = 14
	;
	X = 1, Y = 0
	;
	X = 1, Y = 2
	;
	X = 1, Y = 6
	;
	X = 1, Y = 10
	;
	X = 1, Y = 14
	;
	X = 2, Y = 0
	;
	X = 2, Y = 2
	;
	X = 2, Y = 4
	;
	X = 2, Y = 6
	;
	X = 2, Y = 8
	;
	X = 2, Y = 10
	;
	X = 2, Y = 12
	;
	X = 2, Y = 14
	;
	X = 3, Y = 0
	;
	X = 3, Y = 2
	;
	X = 3, Y = 4
	;
	X = 3, Y = 6
	;
	X = 3, Y = 8
	;
	X = 3, Y = 10
	;
	X = 3, Y = 11
	;
	X = 3, Y = 12
	;
	X = 3, Y = 14
	;
	X = 4, Y = 0
	;
	X = 4, Y = 2
	;
	X = 4, Y = 4
	;
	X = 4, Y = 8
	;
	X = 4, Y = 10
	;
	X = 4, Y = 14
	;
	X = 5, Y = 0
	;
	X = 5, Y = 2
	;
	X = 5, Y = 4
	;
	X = 5, Y = 5
	;
	X = 5, Y = 6
	;
	X = 5, Y = 7
	;
	X = 5, Y = 8
	;
	X = 5, Y = 10
	;
	X = 5, Y = 11
	;
	X = 5, Y = 12
	;
	X = 5, Y = 14
	;
	X = 6, Y = 0
	;
	X = 6, Y = 2
	;
	X = 6, Y = 6
	;
	X = 6, Y = 8
	;
	X = 6, Y = 10
	;
	X = 6, Y = 12
	;
	X = 6, Y = 14
	;
	X = 7, Y = 0
	;
	X = 7, Y = 2
	;
	X = 7, Y = 4
	;
	X = 7, Y = 6
	;
	X = 7, Y = 8
	;
	X = 7, Y = 10
	;
	X = 7, Y = 12
	;
	X = 7, Y = 14
	;
	X = 8, Y = 0
	;
	X = 8, Y = 2
	;
	X = 8, Y = 4
	;
	X = 8, Y = 6
	;
	X = 8, Y = 8
	;
	X = 8, Y = 10
	;
	X = 8, Y = 12
	;
	X = 8, Y = 14
	;
	X = 9, Y = 0
	;
	X = 9, Y = 2
	;
	X = 9, Y = 4
	;
	X = 9, Y = 6
	;
	X = 9, Y = 8
	;
	X = 9, Y = 14
	;
	X = 10, Y = 0
	;
	X = 10, Y = 2
	;
	X = 10, Y = 4
	;
	X = 10, Y = 6
	;
	X = 10, Y = 8
	;
	X = 10, Y = 9
	;
	X = 10, Y = 10
	;
	X = 10, Y = 11
	;
	X = 10, Y = 12
	;
	X = 10, Y = 14
	;
	X = 11, Y = 0
	;
	X = 11, Y = 2
	;
	X = 11, Y = 4
	;
	X = 11, Y = 6
	;
	X = 11, Y = 14
	;
	X = 12, Y = 0
	;
	X = 12, Y = 2
	;
	X = 12, Y = 3
	;
	X = 12, Y = 4
	;
	X = 12, Y = 6
	;
	X = 12, Y = 7
	;
	X = 12, Y = 8
	;
	X = 12, Y = 9
	;
	X = 12, Y = 10
	;
	X = 12, Y = 11
	;
	X = 12, Y = 12
	;
	X = 12, Y = 14
	;
	X = 13, Y = 0
	;
	X = 13, Y = 12
	;
	X = 13, Y = 14
	;
	X = 14, Y = 0
	;
	X = 14, Y = 1
	;
	X = 14, Y = 2
	;
	X = 14, Y = 3
	;
	X = 14, Y = 4
	;
	X = 14, Y = 5
	;
	X = 14, Y = 6
	;
	X = 14, Y = 7
	;
	X = 14, Y = 8
	;
	X = 14, Y = 9
	;
	X = 14, Y = 10
	;
	X = 14, Y = 11
	;
	X = 14, Y = 12
	;
	X = 14, Y = 13
	;
	X = 14, Y = 14
	;
	X > 15; Y > 15.

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

/* The problem is solved is the current state is the final state.                   */
solve_dfs(Problem, State, _, []) :-
	final_state(Problem, State).
/* To perform a state transition we follow the steps below:                         */
/* - We choose a move that can be applied from our current state.                   */
/* - We create the new state which results from performing the chosen move.         */
/* - We check whether the new state is legal (i.e. meets the imposed constraints.   */
/* - Next we check whether the newly produced state was previously visited. If so   */
/*   then we discard such a move, since we're most probably in a loop!              */
/* - If all the above conditions are fulfilled, then we consolidate the chosen move */
/*   and then we continue searching for the solution. Note that we have stored the  */
/*   newly created state for loop checking!                                         */
solve_dfs(Problem, State, History, [Move|Moves]) :-
	move(State, Move),
	update(State, Move, NewState),
	legal(NewState),
	\+ member(NewState, History),
    %print(NewState),
	solve_dfs(Problem, NewState, [NewState|History], Moves).

/*************************************************************************************/
/* Solving the problem.                                                              */
/*************************************************************************************/
solve_problem(Problem, Solution) :-    
	initial_state(Problem, Initial),
	solve_dfs(Problem, Initial, [Initial], Solution).
	