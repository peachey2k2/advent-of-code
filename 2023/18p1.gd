extends SceneTree

var input := ""
var sticks:Array[Stick]

class Stick:
    static var col_sort:Array[Stick] = []
    static var end_sort:Array[Stick] = []
    var col:int
    var start:int
    var end:int

    func _init(c:int, s:int, e:int):
        col = c
        start = s
        end = e
        print(self)
        
        _add_to_col_sort()
        _add_to_end_sort()

    func _add_to_col_sort():
        for i in col_sort.size():
            if self.col < col_sort[i].col:
                col_sort.insert(i, self)
                return
        col_sort.append(self)

    func _add_to_end_sort():
        for i in end_sort.size():
            if self.end < end_sort[i].end:
                end_sort.insert(i, self)
                return
        end_sort.append(self)

    func _to_string():
        return str(col) + " " + str(start) + " " + str(end)



func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

var sum := 0
func main():
    input = "R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)"
    var lines := input.split("\n", false)

    var pos := Vector2i.ZERO

    for line in lines:
        var s := line.split(" ")
        var dist := s[1].to_int()
        match s[0]:
            "L":
                pos.x -= dist
            "R":
                pos.x += dist
            "U":
                sticks.append(Stick.new(pos.x, pos.y, pos.y-dist))
                pos.y -= dist
            "D": 
                sticks.append(Stick.new(pos.x, pos.y+dist, pos.y))
                pos.y += dist
    
    var res = get_area()

    print(res)


func get_area() -> int:
    var area := 0
    while not Stick.col_sort.is_empty():
        var count := 0
        var cur:Stick = Stick.col_sort[0]

        for other in Stick.col_sort:
            if cur.end == other.end:
                for low_end in Stick.end_sort:
                    if low_end.end > max(cur.start, other.start):
                        break
                    if low_end.col > other.col:
                        var dif := low_end.end - cur.end
                        area += dif * other.col - cur.col
                        

                count += 1

        if count > 1:
            print(count)

    return 0