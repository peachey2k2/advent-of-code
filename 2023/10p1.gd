extends SceneTree

var input := ""

var maze:Array[String]
var start:Vector2i 
var direction:Vector2i

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
    
    var length := 1
    if get_item(start + Vector2i.UP) == "7" or get_item(start + Vector2i.UP) == "F":
        direction = Vector2i.UP
    elif get_item(start + Vector2i.DOWN) == "J" or get_item(start + Vector2i.DOWN) == "L":
        direction = Vector2i.DOWN
    else: direction = Vector2i.RIGHT

    var position := start + direction
    while true:
        var item := get_item(position)
        if item == "S": break
        position = move(position)
        length += 1
    
    @warning_ignore("integer_division")
    print(length/2)


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
