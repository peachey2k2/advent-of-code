extends SceneTree

const URL := "http://adventofcode.com/2023/day/3/input"
var input := ""

var input_matrix:PackedStringArray
var mat_size:Vector2i

class Number:
    var num:int
    var start:Vector2i
    var end:Vector2i

    @warning_ignore("shadowed_variable")
    func _init(num:int, start:Vector2i, end:Vector2i):
        self.num = num
        self.start = start
        self.end = end


func _init():
    print("Getting input. This may take a couple seconds.\n")
    var hreq := HTTPRequest.new()
    root.add_child(hreq)
    await hreq.ready
    hreq.request_completed.connect(func(_result, _response_code, _headers, body):
        input = body.get_string_from_utf8()
    )
    hreq.request(URL, ["Cookie: session=" + OS.get_environment("AOC_COOKIE")])
    await hreq.request_completed
    main()
    quit()

func main():
    input_matrix = input.split("\n", false)
    mat_size = Vector2i(input_matrix[0].length(), input_matrix.size())
    var regex := RegEx.new()
    regex.compile("(\\d+)")

    var sum := 0
    for i in input_matrix.size():
        var line := input_matrix[i]
        for m in regex.search_all(line):
            var start := Vector2i(m.get_start(), i)
            var end := Vector2i(m.get_end()-1, i)
            var num := Number.new(m.get_string().to_int(), start, end)
            if is_part_number(num):
                sum += num.num
    print(sum)
            
func is_part_number(num:Number) -> bool:
    for i in range(num.start.x-1, num.end.x+2):
        for j in range(num.start.y-1, num.start.y+2):
            var coords := Vector2i(i, j)
            var item := get_item(coords)
            if not (is_int(item) or item == "."):
                return true
    return false

func get_item(coords:Vector2i) -> String:
    if (
        coords.x < 0 or
        coords.y < 0 or
        coords.x >= mat_size.x or
        coords.y >= mat_size.y
    ):
        return "."
    return input_matrix[coords.y][coords.x]

func is_int(c:String) -> bool:
    var regex := RegEx.new()
    regex.compile("\\d")
    return regex.search(c) != null