extends SceneTree

const URL := "http://adventofcode.com/2023/day/5/input"
var input := ""

var seeds:Array[int]
var maps:Array[Array]

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
    var lines := input.split("\n", true)
    seeds = get_nums_in_str(lines[0].get_slice(": ", 1))
    for i in lines.size():
        if lines[i] == "":
            var new_map:Array = []
            var j := i+2
            while j < lines.size() and lines[j] != "":
                new_map.append(get_nums_in_str(lines[j]))
                j += 1
            maps.append(new_map)
    var next := seeds
    for map in maps:
        next = transform(map, next)
    next.sort()
    print(next[0])

func transform(map:Array, prev:Array[int]) -> Array[int]:
    var next:Array[int] = []
    var queue:Array[int] = []
    for line in map:
        for num in prev:
            if num >= line[1] and num < line[1] + line[2]:
                queue.append(num)
                num += line[0] - line[1]
                next.append(num)
        for num in queue:
            prev.erase(num)
        queue.clear()

    next.append_array(prev)
    return next
                


func get_nums_in_str(s:String) -> Array[int]:
    var out:Array[int] = []
    var regex := RegEx.new()
    regex.compile("\\d+")
    for m in regex.search_all(s):
        out.append(m.get_string().to_int())
    return out
