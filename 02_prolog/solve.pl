use_module(library(apply)).
use_module(library(lists)).
use_module(library(pcre)).

read_lines(L) :-
    current_input(In),
    read_line_to_string(In, Line),
    read_more(Line, L).

read_more(end_of_file, []) :- !.
read_more(Last, [Last|Tail]) :- read_lines(Tail).

parse_record(Line, Rec) :-
    re_matchsub("(\\d+)-(\\d+)\s+(.): ([a-z]+)$", Line,
        re_match{0: _, 1: AS, 2: BS, 3: LetterS, 4: PasswordS}, []
    ),
    string_to_list(LetterS, [Letter]),
    string_to_list(PasswordS, Password),
    number_string(A, AS),
    number_string(B, BS),
    Rec = (A, B, Letter, Password).

is_valid_1(Min, Max, Letter, [Letter|T]) :-
    !,
    compare(>, Max, 0),
    Min2 is max(Min-1, 0),
    Max2 is max(Max-1, 0),
    is_valid_1(Min2, Max2, Letter, T).

is_valid_1(Min, Max, Letter, [_|T]) :- is_valid_1(Min, Max, Letter, T).

is_valid_1(0, _, _, []).

is_valid_1((Min, Max, Letter, Password)) :-
    is_valid_1(Min, Max, Letter, Password).

is_valid_2((Idx1, Idx2, Letter, Password)) :-
    nth1(Idx1, Password, Letter),
    not(nth1(Idx2, Password, Letter)).

is_valid_2((Idx1, Idx2, Letter, Password)) :-
    not(nth1(Idx1, Password, Letter)),
    nth1(Idx2, Password, Letter).

count_valid(P, L, C) :- include(P, L, Valid), length(Valid, C).

main :-
    read_lines(Lines),
    maplist(parse_record, Lines, Records),
    count_valid(is_valid_1, Records, C1),
    count_valid(is_valid_2, Records, C2),
    format("~d, ~d~n", [C1, C2]).
