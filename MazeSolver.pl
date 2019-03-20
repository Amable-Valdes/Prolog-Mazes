
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
:- dynamic initial_state/2.
:- dynamic final_state/2.
:- dynamic c/3.

solve_problem(File_name, Problem, Solution, Time) :-
    write('Nota: el fichero debe estar en la ruta '),
    working_directory(CWD, CWD),
    write(CWD),
    nl,
   %working_directory(_,'C:\Users\Sergio\Documents\Prolog-Mazes').

    load_facts(File_name),
    statistics(runtime, Init_time),
    initial_state(Problem, Initial),
    solve_dfs(Problem, Initial, [Initial], Solution),

    statistics(runtime, End_time),
    Time is End_time-Init_time,
	
    retractall( c(_,_,_) ),
    retractall( initial_state(_,_) ),
    retractall( final_state(_,_) ).
	

load_facts(File_name) :-
    open(File_name, read, Stream),
    read_facts(Stream, _, _),
    close(Stream).

read_facts(_, [], R) :-
	R == end_of_file,
	!.
read_facts(Stream, [T|X], _) :-
	read(Stream, T),
	assert(T),
	read_facts(Stream,X,T).
