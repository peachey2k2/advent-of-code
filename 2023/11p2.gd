extends SceneTree

var input := ""

var galaxies:Array[Vector2i] = []
var big_rows:Array[int] = []
var big_cols:Array[int] = []

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    for i in range(lines.size()-1, -1, -1):
        if not lines[i].contains("#"):
            big_rows.append(i)
    for i in range(lines[0].length()-1, -1, -1):
        var flag := false
        for line in lines:
            if line[i] == "#":
                flag = true
                break
        if not flag:
            big_cols.append(i)
    
    for i in lines.size():
        var line := lines[i]
        for j in line.length():
            if line[j] == "#":
                galaxies.append(Vector2i(j, i))
    
    var out := 0
    for i in galaxies.size():
        for j in range(i+1, galaxies.size()):
            var gal1 := galaxies[i]
            var gal2 := galaxies[j]
            var sum := 0

            for x in range(min(gal1.x, gal2.x), max(gal1.x, gal2.x)):
                if big_cols.has(x):
                    sum += 999999
            
            for y in range(min(gal1.y, gal2.y), max(gal1.y, gal2.y)):
                if big_rows.has(y):
                    sum += 999999

            sum += abs(gal1.x - gal2.x) + abs(gal1.y - gal2.y)
            out += sum
    
    print(out)
