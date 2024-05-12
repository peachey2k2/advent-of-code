extends SceneTree

var input := ""

class Card:
    var id:int
    var winning:Array[int]
    var held:Array[int]

    func _init(line:String):
        var regex1 := RegEx.new()
        var regex2 := RegEx.new()
        regex1.compile("Card\\s+(?<id>\\d+): (?<winning>.*) \\| (?<held>.*)")
        regex2.compile("(\\d+)")

        var res := regex1.search(line)
        id = res.get_string("id").to_int()
        
        var s := res.get_string("winning")
        for r in regex2.search_all(s):
            winning.append(r.get_string().to_int())
        
        s = res.get_string("held")
        for r in regex2.search_all(s):
            held.append(r.get_string().to_int())
    
    func check() -> int:
        var count := 0
        for num in winning:
            if held.has(num):
                count += 1
        return 2**(count-1) if count > 0 else 0

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    var sum := 0
    for line in lines:
        var card := Card.new(line)
        sum += card.check()
    print(sum)
