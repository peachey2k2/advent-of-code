extends SceneTree

var input := ""

var series:Array[Array] = []

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    for line in lines:
        series.append(get_nums_in_str(line))
    
    var sum := 0
    for sequence in series:
        sum += interpolate_next(sequence)
    print(sum)

func interpolate_next(seq:Array) -> int:
    var increments:Array = []
    var flag = false
    for i in seq.size() - 1:
        increments.append(seq[i+1] - seq[i])
        if increments[i] != 0:
            flag = true
    if not flag:
        return seq.back()
    else:
        var inc := interpolate_next(increments)
        return seq.back() + inc

func get_nums_in_str(s:String) -> Array[int]:
    var out:Array[int] = []
    for part in s.split(" "):
        out.append(part.to_int())
    return out