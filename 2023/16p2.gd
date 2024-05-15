extends SceneTree

# this is a bit slow

var input := ""
var map:PackedStringArray
var energized:Dictionary
var highest := 0

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    map = input.split("\n", false)

    for i in map[0].length():
        start_test(Vector2i(i, -1), Vector2i.DOWN)
        start_test(Vector2i(i, map.size()), Vector2i.UP)
    
    for i in map.size():
        start_test(Vector2i(-1, i), Vector2i.RIGHT)
        start_test(Vector2i(map[0].length(), i), Vector2i.LEFT)

    print(highest)

func start_test(pos:Vector2i, dir:Vector2i):
    energized.clear()
    send_laser(pos, dir)
    if energized.size() > highest:
        highest = energized.size()

func send_laser(pos:Vector2i, dir:Vector2i):
    while true:
        pos += dir

        if pos.x<0 or pos.y<0 or pos.x>=map[0].length() or pos.y>=map.size():
            return
    
        if energized.keys().has(pos):
            if energized[pos].has(dir):
                return
            energized[pos].append(dir)
        else:
            energized[pos] = [dir]

        match map[pos.y][pos.x]:
            ".":
                pass
            "/":
                match dir:
                    Vector2i.UP:
                        send_laser(pos, Vector2i.RIGHT)
                    Vector2i.DOWN:
                        send_laser(pos, Vector2i.LEFT)
                    Vector2i.LEFT:
                        send_laser(pos, Vector2i.DOWN)
                    Vector2i.RIGHT:
                        send_laser(pos, Vector2i.UP)
                return
            "\\":
                match dir:
                    Vector2i.UP:
                        send_laser(pos, Vector2i.LEFT)
                    Vector2i.DOWN:
                        send_laser(pos, Vector2i.RIGHT)
                    Vector2i.LEFT:
                        send_laser(pos, Vector2i.UP)
                    Vector2i.RIGHT:
                        send_laser(pos, Vector2i.DOWN)
                return
            "-":
                if dir == Vector2i.UP or dir == Vector2i.DOWN:
                    send_laser(pos, Vector2i.LEFT)
                    send_laser(pos, Vector2i.RIGHT)
                    return
            "|":
                if dir == Vector2i.LEFT or dir == Vector2i.RIGHT:
                    send_laser(pos, Vector2i.UP)
                    send_laser(pos, Vector2i.DOWN)
                    return