
/***************************************************************************/
/* Representation of the state                                             */
/***************************************************************************/
/* p(AndroidCell, BoxCell, GoalCell)                                       */
/***************************************************************************/
/* Representation of the moves                                             */
/***************************************************************************/
/* m(MissionariesInBoat, CannibalsInBoat)                                  */
/***************************************************************************/

initial_state(  maze, p(0,0)  ). 

final_state(  maze, p(3,3)  ).


/*c(0,3,wall).

c(1,0,wall).
c(1,1,wall).
c(1,3,wall).
c(2,3,wall).
c(3,1,wall).
*/
c(X, Y, wall) :-
    X = 0, Y = 3
    ;   
    X = 1, Y = 0
    ;   
    X = 1, Y = 1
    ;   
    X = 1, Y = 3
    ;   
    X = 2, Y = 3
    ;   
    X = 3, Y = 1
    ;   
    X > 3; Y > 3.   
    
	


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
    print(NewState),
	solve_dfs(Problem, NewState, [NewState|History], Moves).

/*************************************************************************************/
/* Solving the problem.                                                              */
/*************************************************************************************/
solve_problem(Problem, Solution) :-    
	initial_state(Problem, Initial),
	solve_dfs(Problem, Initial, [Initial], Solution).
	