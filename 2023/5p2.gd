extends SceneTree

var input := ""

var seeds:Array[Seed]
var maps:Array[Array]

# todo: this works for the example, but not the input. fix it.
# well it kinda does, it just has some false positives at the start of the array
# still needs a more proper fix tho

class Seed:
    var s:int
    var r:int
    var flag:bool = false

    @warning_ignore("shadowed_variable")
    func _init(s:int, r:int):
        self.s = s # start
        self.r = r # range
        if s < 0:
            printerr("s is negative")
        if r < 0:
            printerr("r is negative")
            
    
    func shift(by:int):
        s += by
        if s < 0:
            printerr("s is negative (%d + %d < 0" % [s, by])
        return self
    
    # slices itself appropriately, first element is always the transformable one
    func slice(map:Array) -> Array[Seed]:
        var out:Array[Seed] = []
        if s >= map[1]+map[2]:
            pass
        elif s < map[1]:
            if s+r <= map[1]:
                pass
            elif s+r < map[1]+map[2]:
                out.append(Seed.new(map[1], r-(map[1]-s)))
                out.append(Seed.new(s, map[1] - s))
            else:
                out.append(Seed.new(map[1], map[2]))
                out.append(Seed.new(s, map[1]-s))
                out.append(Seed.new(map[1]+map[2], r-(map[1]-s+map[2])))
        else:
            if s+r < map[1]+map[2]:
                out.append(Seed.new(s, r))
            else:
                out.append(Seed.new(s, map[1]+map[2]-s))
                out.append(Seed.new(map[1]+map[2], r - (map[1]+map[2]-s)))

        return out
    
    func _to_string():
        return str(s) + "-" + str(r)

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", true)
    var nums := get_nums_in_str(lines[0].get_slice(": ", 1))

    for i in range(0, nums.size(), 2):
        seeds.append(Seed.new(nums[i], nums[i+1]))

    for i in lines.size():
        if lines[i] == "":
            var new_map:Array = []
            var j := i+2
            while j < lines.size() and lines[j] != "":
                new_map.append(get_nums_in_str(lines[j]))
                j += 1
            maps.append(new_map)
    var next := seeds
    for map in maps:
        next = clear_duplicates(next)
        next = transform(map, next)

    var sorted = next.map(func(a:Seed): return a.s)
    sorted.sort()
    print(sorted)
    print(next)
    print(sorted[0])

func clear_duplicates(arr:Array[Seed]) -> Array[Seed]:
    var out:Array[Seed] = []
    for seed_in in arr:
        var flag := false
        for seed_out in out:
            if seed_in.s == seed_out.s and seed_in.r == seed_out.r:
                flag = true
                break
        if not flag:
            out.append(seed_in)
    return out
        

func transform(map:Array, prev:Array[Seed]) -> Array[Seed]:
    var next:Array[Seed] = []
    for line in map:
        for num in prev:
            if num.r == 0: continue
            var slices := num.slice(line)
            if not slices.is_empty():
                num.flag = true
                var slice:Seed = slices.pop_front()
                slice.shift(line[0]-line[1])

                var flag := false
                for num2 in next:
                    if num2.s == num.s:
                        flag = true
                        break
                if not flag: next.append(slice)

                # print(num, "->", line, " ==== " ,slices)
                prev.append_array(slices)

    for num in prev:
        if num.flag == false:
            next.append(num)

    var queue:Array[Seed] = []
    for i in next.size():
        if next[i].r == 0: queue.append(next[i])
    for num in queue:
        next.erase(num)
    return next

func get_nums_in_str(s:String) -> Array[int]:
    var out:Array[int] = []
    var regex := RegEx.new()
    regex.compile("\\d+")
    for m in regex.search_all(s):
        out.append(m.get_string().to_int())
    return out
