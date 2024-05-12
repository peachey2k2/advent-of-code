extends SceneTree

var input := ""

var race:Race

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
    race = Race.new(get_num(lines[0]), get_num(lines[1]))
    
    var out := race.get_win_count()
    print(out)


func get_num(s:String) -> int:
    var out := ""
    var regex := RegEx.new()
    regex.compile("\\d+")
    for m in regex.search_all(s):
        out += m.get_string()
    return out.to_int()