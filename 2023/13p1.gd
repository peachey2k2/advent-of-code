extends SceneTree

var input := ""
var grids:Array[Array] = [[]]

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", true)
    var idx:int = 0
    for line in lines:
        if line.is_empty():
            idx += 1
            grids.append([])
            continue
        grids[idx].append(line)
    if grids[-1].is_empty(): grids.pop_back()
    
    var sum := 0
    for grid in grids:
        sum += find_mirror(grid)
    print(sum)

func find_mirror(grid:Array) -> int:
    for i in grid.size()-1:
        var idx1 := i
        var idx2 := i+1
        var flag := false
        while idx1 >= 0 and idx2 < grid.size():
            if grid[idx1] != grid[idx2]:
                flag = true
                break
            idx1 -= 1
            idx2 += 1
        if not flag:
            return (i+1)*100
    
    for i in grid[0].length()-1:
        var idx1:int = i
        var idx2:int = i+1
        var flag := false
        while idx1 >= 0 and idx2 < grid[0].length():
            for row in grid:
                if row[idx1] != row[idx2]:
                    flag = true
                    break
            idx1 -= 1
            idx2 += 1
            if flag: break
        if not flag:
            return i+1
    return 0
            
        




