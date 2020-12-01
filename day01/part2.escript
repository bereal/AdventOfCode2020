#!/usr/bin/env escript

read() -> read([]).

read(L) -> case io:fread("", "~d") of
    {ok, [D]} -> read([D|L]);
    eof -> L
end.

solve([H|Tail], Chosen, N, Sum)  ->
    Fallthrough = fun() -> solve(Tail, Chosen, N, Sum) end,
    Found = (H == Sum) and (N == 1),
    if
        Found -> {ok, H * lists:foldr(fun (X, Y) -> X*Y end, 1, Chosen)};
        H < Sum -> case solve(Tail, [H|Chosen], N-1, Sum-H) of
            {ok, V} -> {ok, V};
            _ -> Fallthrough()
        end;
        true -> Fallthrough()
    end;

solve([], _, _, _) -> fail.

main(_) ->
    L = read(),
    {ok, V} = solve(L, [], 3, 2020),
    io:format("~p~n", [V]).
