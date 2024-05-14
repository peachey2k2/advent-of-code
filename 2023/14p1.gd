extends SceneTree

var input := ""
var dish:PackedStringArray

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    dish = input.split("\n", false)

    for i in dish.size():
        for j in dish[i].length():
            if dish[i][j] != "O": continue
            dish[i][j] = "."
            var k := i
            while true:
                k -= 1
                if k < 0 or dish[k][j] != ".":
                    dish[k+1][j] = "O"
                    break
    
    var sum := 0
    for i in dish.size():
        sum += dish[i].count("O") * (dish.size() - i )
    print(sum)
