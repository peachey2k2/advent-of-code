extends SceneTree

var input := ""
var map:PackedStringArray
var energized:Dictionary

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    map = input.split("\n", false)

    send_laser(Vector2i(-1, 0), Vector2i.RIGHT)

    print(energized.size())

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