extends SceneTree

var input := ""
var words:PackedStringArray = []

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    words = input.strip_edges().split(",", false)

    var out := 0
    for word in words:
        out += run_hash(word)
    print(out)


func run_hash(word:String) -> int:
    var sum := 0
    for c in word.to_ascii_buffer():
        sum += c
        sum *= 17
        sum %= 256
    return sum