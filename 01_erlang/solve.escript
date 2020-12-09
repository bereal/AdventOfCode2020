#!/usr/bin/env escript

read() -> read([]).

read(L) -> case io:fread("", "~d") of
    {ok, [D]} -> read([D|L]);
    eof -> L
end.


prod(L) -> lists:foldr(fun (X, Y) -> X*Y end, 1, L).


find_sum(L, N, Sum) ->
    {ok, V} = find_sum(L, N, Sum, []),
    V.

find_sum([H|T], N, Sum, Chosen)  ->
    Found = (H == Sum) and (N == 1),
    if
        Found -> {ok, [H|Chosen]};
        H < Sum -> case find_sum(T, N-1, Sum-H, [H|Chosen]) of
            {ok, V} -> {ok, V};
            _ -> find_sum(T, N, Sum, Chosen)
        end;
        true -> fail
    end;

find_sum([], _, _, _) -> fail.


main(_) ->
    L = lists:sort(read()),
    Part1 = prod(find_sum(L, 2, 2020)),
    Part2 = prod(find_sum(L, 3, 2020)),
    io:format("~p ~p~n", [Part1, Part2]).