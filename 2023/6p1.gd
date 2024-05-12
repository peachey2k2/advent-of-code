extends SceneTree

var input := ""

var races:Array[Race] = []

class Race:
    var time:int
    var dist:int

    func _init(t:int, d:int):
        time = t
        dist = d
    
    func get_win_count() -> int:
        var sum := 0
        if not time % 2:
            sum -= 1
        
        @warning_ignore("integer_division")
        var cur := time / 2
        while true:
            if cur * (time - cur) < dist: break
            sum += 2
            cur -= 1
        return sum if sum > 0 else 0



func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    var times := get_nums_in_str(lines[0])
    var dists := get_nums_in_str(lines[1])
    for i in times.size():
        races.append(Race.new(times[i], dists[i]))
    
    var out := 1
    for race in races:
        out *= race.get_win_count()
    print(out)


func get_nums_in_str(s:String) -> Array[int]:
    var out:Array[int] = []
    var regex := RegEx.new()
    regex.compile("\\d+")
    for m in regex.search_all(s):
        out.append(m.get_string().to_int())
    return out