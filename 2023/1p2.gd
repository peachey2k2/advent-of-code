extends SceneTree

var input := ""

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
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

    line = numberise(line)

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

const delims := ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
func numberise(line:String) -> String:
    var out := line
    for i in delims.size():
        var delim:String = delims[i]
        var idx := -1
        while true:
            idx = line.find(delim, idx+1)
            if idx == -1: break
            out[idx] = str(i+1)
    return out
