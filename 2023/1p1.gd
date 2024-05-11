extends SceneTree

const URL := "http://adventofcode.com/2023/day/1/input"
var input := ""

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
    var lines := input.split("\n", false)
    var sum := 0
    for line in lines:
        sum += get_sum(line)
    print(sum)

func get_sum(line:String) -> int:
    var sum := 0

    for i in line.length():
        var chr := line[i]
        if chr.is_valid_int():
            sum += chr.to_int() * 10
            break
    for i in range(line.length()-1, -1, -1):
        var chr := line[i]
        if chr.is_valid_int():
            sum += chr.to_int()
            break
    return sum