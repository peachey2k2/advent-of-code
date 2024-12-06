defmodule Solution do
    def move(puzzle, x, y, look) do
        {next_x, next_y} = case look do
            :up    -> {x, y-1}
            :down  -> {x, y+1}
            :left  -> {x-1, y}
            :right -> {x+1, y}
        end

        {x_new, y_new, look_new} =
        if String.at(Enum.at(puzzle, next_y), next_x) == "#" do
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
        if x_new >= 0 and x_new < 130 and y_new >= 0 and y_new < 130 do
            MapSet.put(move(puzzle, x_new, y_new, look_new), {x, y})
        else
            MapSet.put(MapSet.new(), {x, y})
        end
    end
end

{:ok, input} = File.read("../input.txt")
lines = String.split(input, "\n")

caret_pos = case String.split(input, "^", parts: 2) do
    [left, _] -> String.length(left)
end

{x, y} = {rem(caret_pos, 131), div(caret_pos, 131)}

IO.puts(MapSet.size(Solution.move(lines, x, y, :up)))
