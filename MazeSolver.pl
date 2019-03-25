/***************************************************************************/
/* Representation of the state                                             */
/***************************************************************************/
/*
 * The states are represented as follows:
 * p(X,Y).
 * where X and Y represents the cartesian coordinates of the location
 * point of the maze
 */

/*                                                                      */
/* We declare dynamic predicates as we are going to assert them         */
/* reading a file. [See read_facts/3]                                   */
/*                                                                      */
/* The predicate initial_state(X,Y) represents the starting point       */
/* of the maze.                                                         */
/* Equivalent for final state                                           */
/*                                                                      */
/* c(X,Y,Content) is a predicate that given a position gives you        */
/* whether we can go through the cell or not.                           */
/*                                                                      */
/* Following the closed-world assumption, we only declare the           */
/* ones that cannot be gone through (walls).                            */
/*                                                                      */
/* We have two approaches for implementing this predicate:              */
/*  - as a rule                                                         */
/*  - as a sequence of facts                                            */
/* We decided to use the 2nd one in almost all the maze examples.       */
/* [An example implementation of the rule appoach can be seen in        */
/*  "MazeSolver_Maze0_with_rule.pl" file located in                     */
/*  "embedded facts or rules examples" directory]                       */
/*                                                                      */
:- dynamic initial_state/2.
:- dynamic final_state/2.
:- dynamic c/3.

/***************************************************************************/
/* Now we implement our table of moves.                                    */
/***************************************************************************/
/*
 * We can move upwards, downwards, to the left and to the right
 * Each movement is considered from an static approach.
 */
move(  p( _, _ ), up    ).
move(  p( _, _ ), down  ).
move(  p( _, _ ), left  ).
move(  p( _, _ ), right ).



/***************************************************************************/
/* We now implement the state update functionality.                        */
/***************************************************************************/
/*                                                   */
/*                                                   */
/*      X\Y     0         1         2		     */
/*         ╔═════════╦═════════╦═════════╗	     */
/*      0  ║    -    ║ (X-1,Y) ║    -    ║	     */
/*         ╠═════════╬═════════╬═════════╣	     */
/*      1  ║ (X,Y-1) ║  (X,Y)  ║ (X,Y+1) ║	     */
/*         ╠═════════╬═════════╬═════════╣	     */
/*      2  ║    -    ║ (X+1,Y) ║    -    ║	     */
/*         ╚═════════╩═════════╩═════════╝	     */
/*                                                   */

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
/*
 * The location cannot be out of the maze, so we define lower limits for both
 * coordinates
 *
 * Also we have to check whether the (X,Y) coordinates represents a
 * wall or an empty space. We only can do the move if the cell is empty.
 * As we just assert the wall cells, we use the negation as failure.
 */
legal(  p(X,Y) ) :-
    X >= 0,
    Y >= 0,
    \+ c(X,Y,wall).



/***************************************************************************/
/* A reusable depth-first problem solving framework.                       */
/***************************************************************************/

solve_dfs(Problem, State, _, []) :-
	final_state(Problem, State).

solve_dfs(Problem, State, History, [Move|Moves]) :-
	move(State, Move),
	update(State, Move, NewState),
	legal(NewState),
	\+ member(NewState, History),
	%print(NewState),
	solve_dfs(Problem, NewState, [NewState|History], Moves).

/****************************************************************************/
/* Solving the problem.                                                     */
/****************************************************************************/

/*                                                                          */
/* MAIN RULE. USED AS QUERY.                                                */
/*                                                                          */
/* EXAMPLE OF USAGE: solve_problem('maze5.pl', Problem, Solution, _).       */
/* (The name of the problem is infered, the solution is given as output     */
/* and the time is not shown).                                              */
/*                                                                          */
solve_problem(File_name, Problem, Solution, Time) :-
    write('Note: the file must be located in the path '),

    /*                                                         */
    /* This is where Prolog is working as default.             */
    /* Can be changed using "working_directory(_, New_CWD)"    */
    /*                                                         */
    working_directory(CWD, CWD),

    write(CWD),
    nl, % new line

    /* The following predicates are used to reset the buffer */
    /* IMPORTANT:                                            */
    /* Comment these 3 lines in order to get more than one   */
    /* solution of the maze. But take into account that      */
    /* doing that you cannot solve another instance of the   */
    /* maze unless executeing them manually in the ?- prompt */
    retractall( c(_,_,_) ),
    retractall( initial_state(_,_) ),
    retractall( final_state(_,_) ),

    load_facts(File_name), % load the File_name instance of the problem
    initial_state(Problem, Initial),

    statistics(runtime, Init_time), % measuring of the time [See results in...]
    solve_dfs(Problem, Initial, [Initial], Solution),
    statistics(runtime, End_time),

    Time is End_time-Init_time. % measuring of the time [See results in...]


% END OF solve_problem RULE

load_facts(File_name) :-
    open(File_name, read, Stream), % open the File given as input (must include the extension)
    read_facts(Stream, _, _), % read AND ASSERT the facts
    close(Stream).

read_facts(_, [], R) :-
	R == end_of_file,
	!. % Green Cut at the end of the file
read_facts(Stream, [T|X], _) :-
	read(Stream, T),
	assert(T), % only the dynamic predicates can be asserted (kind of format checking)
	read_facts(Stream,X,T).
