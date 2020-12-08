#!/usr/bin/env escript

read() -> read([]).

read(L) -> case io:fread("", "~d") of
    {ok, [D]} -> read([D|L]);
    eof -> L
end.


part1(L) -> part1(L, sets:new()).

part1([H|T], Seen) ->
    Found = sets:is_element(2020 - H, Seen),
    if
        Found -> H * (2020 - H);
        true -> part1(T, sets:add_element(H, Seen))
    end.


part2(L) ->
    {ok, V} = part2(L, [], 3, 2020),
    V.

part2([H|T], Chosen, N, Sum)  ->
    Fallthrough = fun() -> part2(T, Chosen, N, Sum) end,
    Found = (H == Sum) and (N == 1),
    if
        Found -> {ok, H * lists:foldr(fun (X, Y) -> X*Y end, 1, Chosen)};
        H < Sum -> case part2(T, [H|Chosen], N-1, Sum-H) of
            {ok, V} -> {ok, V};
            _ -> Fallthrough()
        end;
        true -> Fallthrough()
    end;

part2([], _, _, _) -> fail.


main(_) ->
    L = read(),
    io:format("~p ~p~n", [part1(L), part2(L)]).