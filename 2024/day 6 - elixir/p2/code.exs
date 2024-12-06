defmodule Solution do
    def move(puzzle, x, y, look, obs_x, obs_y, moves, seen) do
        {next_x, next_y} = case look do
            :up    -> {x, y-1}
            :down  -> {x, y+1}
            :left  -> {x-1, y}
            :right -> {x+1, y}
        end

        {x_new, y_new, look_new} =
        if String.at(Enum.at(puzzle, next_y), next_x) == "#" or {next_x, next_y} == {obs_x, obs_y} do
            { x, y,
                case look do
                    :up    -> :right
                    :right -> :down
                    :down  -> :left
                    :left  -> :up
                end
            }
        else
            {next_x, next_y, look}
        end
        cond do
            x_new >= 0 and x_new < 130 and y_new >= 0 and y_new < 130 ->
                cond do
                    MapSet.member?(seen, {x_new, y_new, look_new}) -> 1
                    true -> move(puzzle, x_new, y_new, look_new, obs_x, obs_y, moves+1,
                        MapSet.put(seen, {x_new, y_new, look_new}))
                end
            true -> 0
        end
    end

    def try_obstacles(puzzle, x_start, y_start) do
        puzzle
        |> Enum.with_index()
        |> Enum.reduce(0, fn {line, y}, accum ->
            line
            |> String.graphemes()
            |> Enum.with_index()
            |> Enum.reduce(accum, fn {char, x}, a ->
                if char == "." do
                    a + move(puzzle, x_start, y_start, :up, x, y, 0, MapSet.new())
                else
                    a
                end
            end)
        end)
    end
end

{:ok, input} = File.read("../input.txt")
lines = String.split(input, "\n")

caret_pos = case String.split(input, "^", parts: 2) do
    [left, _] -> String.length(left)
end

{x, y} = {rem(caret_pos, 131), div(caret_pos, 131)}

IO.puts(Solution.try_obstacles(lines, x, y))
