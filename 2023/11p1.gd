extends SceneTree

var input := ""

var galaxies:Array[Vector2i] = []

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    for i in range(lines.size()-1, -1, -1):
        if not lines[i].contains("#"):
            lines.insert(i, lines[i])
    for i in range(lines[0].length()-1, -1, -1):
        var flag := false
        for line in lines:
            if line[i] == "#":
                flag = true
                break
        if not flag:
            for j in lines.size():
                lines[j] = lines[j].left(i) + "." + lines[j].right(-i)
    
    for i in lines.size():
        var line := lines[i]
        for j in line.length():
            if line[j] == "#":
                galaxies.append(Vector2i(j, i))
    
    var out := 0
    for i in galaxies.size():
        for j in range(i+1, galaxies.size()):
            var sum := galaxies[i] - galaxies[j]
            out += abs(sum.x) + abs(sum.y)
    
    print(out)
