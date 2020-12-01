#!/usr/bin/env escript

run(Seen) ->
    {ok, [D]} = io:fread("", "~d") ,
    Found = sets:is_element(2020 - D, Seen),
    if
        Found -> D * (2020 - D);
        true -> run(sets:add_element(D, Seen))
    end.

main(_) -> io:format("~p~n", [run(sets:new())]).
