extends SceneTree

var input := ""
var dish:Array[String] = []
var hashes:Array[int] = []

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    for row in input.split("\n", false): 
        dish.append(row)

    for itr in 1000000000: # ONE BILLION????
        cycle()
        var new_hash := dish.hash() # sike! praise the loop
        for h in hashes.size():
            if hashes[h] == new_hash:
                var wrapped:int = wrap(1000000000-h, 0, itr-h)
                for j in wrapped-1:
                    cycle()
                var sum := 0
                for i in dish.size():
                    sum += dish[i].count("O") * (dish.size() - i )
                print(sum)
                return
                
        hashes.append(new_hash)
            
    

func cycle():
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

    for i in dish[0].length():
        for j in dish.size():
            if dish[j][i] != "O": continue
            dish[j][i] = "."
            var k := i
            while true:
                k -= 1
                if k < 0 or dish[j][k] != ".":
                    dish[j][k+1] = "O"
                    break

    for i in range(dish.size()-1, -1, -1):
        for j in dish[i].length():
            if dish[i][j] != "O": continue
            dish[i][j] = "."
            var k := i
            while true:
                k += 1
                if k >= dish.size() or dish[k][j] != ".":
                    dish[k-1][j] = "O"
                    break

    for i in range(dish[0].length()-1, -1, -1):
        for j in dish.size():
            if dish[j][i] != "O": continue
            dish[j][i] = "."
            var k := i
            while true:
                k += 1
                if k >= dish[0].length() or dish[j][k] != ".":
                    dish[j][k-1] = "O"
                    break