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
            Data ++ [[list_to_integer(Num) || Num <- Curr]];
        Line ->
            {NewIdx, Next, NewData} = case Pos of
                0 ->
                    {_, Capt} = re:run(Line, "\\w+\\: X\\+(\\d+), Y\\+(\\d+)", [{capture, all, list}]),
                    {Idx, tl(Capt), Data};
                1 ->
                    {_, Capt} = re:run(Line, "\\w+\\: X\\+(\\d+), Y\\+(\\d+)", [{capture, all, list}]),
                    {Idx, Curr ++ tl(Capt), Data};
                2 ->
                    {_, Capt} = re:run(Line, "\\w+\\: X\\=(\\d+), Y\\=(\\d+)", [{capture, all, list}]),
                    {Idx, Curr ++ tl(Capt), Data};
                3 ->
                    Bundle = [list_to_integer(Num) || Num <- Curr],
                    {Idx + 1, [], Data ++ [Bundle]}
            end,
            read_lines(File, (Pos + 1) rem 4, NewIdx, NewData, Next)
    end.

process([]) -> 0;
process([Nums | Tail]) ->
    InitB = min(100, min(
        lists:nth(5, Nums) div lists:nth(3, Nums),
        lists:nth(6, Nums) div lists:nth(4, Nums)
    )),
    Res = case iterate(InitB, Nums) of
        {some, {A, B}} -> 3*A + B;
        {none, _} -> 0
    end,
    Res + process(Tail).

iterate(B, Nums) ->
    case B of
        X when X < 0 -> {none, {0, 0}};
        _ ->
            {RemX, RemY} = {
                lists:nth(5, Nums) - lists:nth(3, Nums) * B,
                lists:nth(6, Nums) - lists:nth(4, Nums) * B
            },
            Mod1 = RemX rem lists:nth(1, Nums),
            Mod2 = RemY rem lists:nth(2, Nums),
            Div1 = RemX div lists:nth(1, Nums),
            Div2 = RemY div lists:nth(2, Nums),
            if
                (Mod1 == Mod2) and (Mod1 == 0) and (Div1 == Div2) ->
                    {some, {Div1, B}};
                true ->
                    iterate(B-1, Nums)
            end
    end.
