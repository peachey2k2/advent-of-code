-module(code_).
-export([run/0]).

run() ->
    case file:open("../input.txt", [read]) of
        {ok, File} ->
            Data = read_lines(File, 0, 0, [], []),
            file:close(File),
            Sum = process(Data),
            io:format("~p~n", [Sum]),
            ok;
        {error, reason} -> error("can't open file")
    end.

read_lines(File, Pos, Idx, Data, Curr) when Pos >= 0, Pos < 4 ->
    case io:get_line(File, "") of
        eof ->
            Data ++ [Curr];
        Line ->
            {NewIdx, Next, NewData} = case Pos of
                0 ->
                    {_, Capt} = re:run(Line, "\\w+\\: X\\+(\\d+), Y\\+(\\d+)", [{capture, all, list}]),
                    {Idx, [list_to_integer(Num) || Num <- tl(Capt)], Data};
                1 ->
                    {_, Capt} = re:run(Line, "\\w+\\: X\\+(\\d+), Y\\+(\\d+)", [{capture, all, list}]),
                    {Idx, Curr ++ [list_to_integer(Num) || Num <- tl(Capt)], Data};
                2 ->
                    {_, Capt} = re:run(Line, "\\w+\\: X\\=(\\d+), Y\\=(\\d+)", [{capture, all, list}]),
                    {Idx, Curr ++ [list_to_integer(Num) + 10000000000000 || Num <- tl(Capt)], Data};
                3 ->
                    {Idx + 1, [], Data ++ [Curr]}
            end,
            read_lines(File, (Pos + 1) rem 4, NewIdx, NewData, Next)
    end.

process([]) -> 0;
process([Nums | Tail]) ->
    D  = lists:nth(1, Nums) * lists:nth(4, Nums) - lists:nth(2, Nums) * lists:nth(3, Nums),
    Dx = lists:nth(5, Nums) * lists:nth(4, Nums) - lists:nth(6, Nums) * lists:nth(3, Nums),
    Dy = lists:nth(1, Nums) * lists:nth(6, Nums) - lists:nth(2, Nums) * lists:nth(5, Nums),
    if
        (Dx rem D =/= 0) or (Dy rem D =/= 0) -> process(Tail);
        true -> (Dx div D)*3 + (Dy div D) + process(Tail)
    end.



