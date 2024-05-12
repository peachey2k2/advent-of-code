extends SceneTree

var input := ""

class Card:
    var id:int
    var winning:Array[int]
    var held:Array[int]

    static var copies:Dictionary

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
        count = min(id + count, 201) - id
        var mult = copies[id]+1 if copies.keys().has(id) else 1
        for i in range(id+1, id+1+count):
            if not copies.keys().has(i):
                copies[i] = 0
            copies[i] += mult
        return mult

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
