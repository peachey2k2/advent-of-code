extends SceneTree

# todo: this is SLOOOOOW and doesn't work

var input := ""

var maze:Array[String] = []
var start:Vector2i 
var direction:Vector2i

var coords:Array[Vector2i] = []
var labyrinth:Array[Array] = []

var inside:Array[Vector2i] = []
var outside:Array[Vector2i] = []

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    for line in lines:
        maze.append(line)
        var pos := line.find("S")
        if pos != -1:
            start = Vector2i(pos, maze.size()-1)
    
    maze[start.y][start.x] = get_start_pipe()
    coords.append(start)

    if get_item(start + Vector2i.UP) == "7" or get_item(start + Vector2i.UP) == "F":
        direction = Vector2i.UP
    elif get_item(start + Vector2i.DOWN) == "J" or get_item(start + Vector2i.DOWN) == "L":
        direction = Vector2i.DOWN
    else: direction = Vector2i.RIGHT

    var position := start + direction
    while true:
        if position == start: break
        coords.append(position)
        position = move(position)
    
    construct_labyrinth()

    for i in [3*start.x, 3*start.x+2]:
        for j in [3*start.y, 3*start.y+2]:
            if labyrinth[i][j] == 1: continue
            var vec := Vector2i(j, i)
            for loc in inside:
                if vec == loc: continue
            for loc in outside:
                if vec == loc: continue
            var visited:Array[Vector2i] = []
            if bfs(vec, visited):
                for v in visited:
                    if v.x % 3 == 1 and v.y % 3 == 1:
                        inside.append(v)
                        print(inside.size())
                        return
            else:
                for v in visited:
                    if v.x % 3 == 1 and v.y % 3 == 1:
                        outside.append(v)

func get_start_pipe() -> String:
    var connections := 0
    var cur_item := ""
    
    cur_item = get_item(start + Vector2i.UP)
    if cur_item == "7" or cur_item == "F" or cur_item == "|":
        connections |= 1 << 3

    cur_item = get_item(start + Vector2i.DOWN)
    if cur_item == "L" or cur_item == "J" or cur_item == "|":
        connections |= 1 << 2
        
    cur_item = get_item(start + Vector2i.LEFT)
    if cur_item == "L" or cur_item == "F" or cur_item == "-":
        connections |= 1 << 1

    cur_item = get_item(start + Vector2i.RIGHT)
    if cur_item == "7" or cur_item == "J" or cur_item == "-":
        connections |= 1 << 0

    match connections:
        0b1100: return "|"
        0b1010: return "J"
        0b1001: return "L"
        0b0110: return "7"
        0b0101: return "F"
        0b0011: return "-"
        _: return ""

func bfs(begin:Vector2i, visited:Array[Vector2i]) -> bool:
    var queue:Array[Vector2i] = [begin]

    while not queue.is_empty():
        var next:Vector2i = queue.pop_front()

        if next.x % 3 == 1 and next.y % 3 == 1:
            for vec in outside:
                if next == vec:
                    return false

        if next.x < 0 or next.y < 0 or next.x >= labyrinth[0].size() or next.y >= labyrinth.size():
            return false

        if labyrinth[next.y][next.x] == 1:
            continue

        var flag := false
        for point in visited:
            if next == point:
                flag = true
                break
        if flag: continue
        visited.append(next)

        queue.append(next + Vector2i.UP)
        queue.append(next + Vector2i.DOWN)
        queue.append(next + Vector2i.LEFT)
        queue.append(next + Vector2i.RIGHT)

    return true

func construct_labyrinth():
    for i in maze.size():
        var line := maze[i]
        var next_row := [[],[],[]]
        for j in line.length():
            var next_block:Array[Array]
            var flag := false
            for coord in coords:
                if coord.x == j and coord.y == i:
                    flag = true
                    break
            if flag:
                match line[j]:
                    "F": next_block = [[0,0,0],[0,1,1],[0,1,0]]
                    "7": next_block = [[0,0,0],[1,1,0],[0,1,0]]
                    "L": next_block = [[0,1,0],[0,1,1],[0,0,0]]
                    "J": next_block = [[0,1,0],[1,1,0],[0,0,0]]
                    "-": next_block = [[0,0,0],[1,1,1],[0,0,0]]
                    "|": next_block = [[0,1,0],[0,1,0],[0,1,0]]
            else:
                next_block = [[0,0,0],[0,0,0],[0,0,0]]
            next_row[0].append_array(next_block[0])
            next_row[1].append_array(next_block[1])
            next_row[2].append_array(next_block[2])
        labyrinth.append(next_row[0])
        labyrinth.append(next_row[1])
        labyrinth.append(next_row[2])


func get_item(pos:Vector2i) -> String:
    return maze[pos.y][pos.x]

func move(pos:Vector2i) -> Vector2i:
    var item := get_item(pos)
    match direction:
        Vector2i.UP:
            if item == "|":
                direction = Vector2i.UP
            elif item == "7":
                direction = Vector2.LEFT
            else:
                direction = Vector2.RIGHT
        Vector2i.DOWN:
            if item == "|":
                direction = Vector2i.DOWN
            elif item == "J":
                direction = Vector2.LEFT
            else:
                direction = Vector2.RIGHT
        Vector2i.LEFT:
            if item == "-":
                direction = Vector2i.LEFT
            elif item == "L":
                direction = Vector2.UP
            else:
                direction = Vector2.DOWN
        Vector2i.RIGHT:
            if item == "-":
                direction = Vector2i.RIGHT
            elif item == "J":
                direction = Vector2.UP
            else:
                direction = Vector2.DOWN
    return pos + direction
