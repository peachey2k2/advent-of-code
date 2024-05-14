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
        sum += find_new_line(grid)
    print(sum)

func find_new_line(grid:Array) -> int:
    var old_line := find_mirror(grid, 0)
    for x in grid[0].length():
        for y in grid.size():
            grid[y][x] = "#" if grid[y][x] == "." else "."
            var out := find_mirror(grid, old_line)
            if out != 0:
                return out
            grid[y][x] = "#" if grid[y][x] == "." else "."
    return 0

func find_mirror(grid:Array, old_line:int) -> int:
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
        if not flag and (i+1)*100 != old_line:
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
        if not flag and i+1 != old_line:
            return i+1
    return 0
            
        




