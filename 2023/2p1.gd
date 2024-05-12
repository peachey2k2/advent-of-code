extends SceneTree

var input := ""

class Game:
    var id:int
    var sets:Array[Vector3i]

    func _init(line:String):
        var regex1 := RegEx.new()
        var regex2 := RegEx.new()
        regex1.compile("Game (?<id>\\d+): (?<rest>.*)")
        regex2.compile("(?<num>\\d+)(?<col>[a-z]+)")
        var res := regex1.search(line)
        id = res.get_string("id").to_int()
        for batch in res.get_string("rest").replace(" ", "").split(";"):
            var cur_set := Vector3i.ZERO
            for stack in batch.split(","):
                res = regex2.search(stack)
                var num:int = res.get_string("num").to_int()
                match res.get_string("col"):
                    "red":   cur_set.x = num
                    "green": cur_set.y = num
                    "blue":  cur_set.z = num
            sets.append(cur_set)

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    var sum := 0
    for line in lines:
        var game := Game.new(line)
        if is_possible(game):
            sum += game.id
    print(sum)

func is_possible(game) -> bool:
    for cur_set in game.sets:
        if (
            cur_set.x > 12 or
            cur_set.y > 13 or
            cur_set.z > 14
        ):
            return false
    return true