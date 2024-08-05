extends SceneTree

# it's only day 17, how hard could it be

const DIRECTIONS:Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

var input := ""
var map:Array[Array] = []

class TreeNode:
    var pos:Vector2i
    var move:Vector2i
    var dis:int
    var next:Array[TreeNode] = []
    var is_valid:bool = true

    func _init(p:Vector2i, m:Vector2i, d:int):
        pos = p
        move = m
        dis = d

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    input = "2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533"
    var lines := input.split("\n", false)
    for line in lines:
        var new_arr := []
        for c in line:
            new_arr.append(c.to_int())
        map.append(new_arr)

    var res := djikstra(Vector2i.ZERO)
    for a in map:
        print(a)
    print(res)
        

func djikstra(start:Vector2i) -> int:
    var queue:Array[TreeNode] = [TreeNode.new(start, Vector2i.ZERO, 0)]
    var visited:Array[TreeNode] = []

    while not queue.is_empty():
        var cur:TreeNode = queue.pop_front()
        var flag := false
        var flag2 := false

        if cur.pos == Vector2i(4,0):
            print(cur.dis)

        for node in visited:
            if cur.pos == node.pos:
                if node.dis > cur.dis:
                    var dif := node.dis - cur.dis
                    for vis in node.next:
                        vis.dis -= dif
                    node.dis = cur.dis
                    node.move = cur.move
                    flag2 = true
                    break
                else:
                    flag = true
                    break
                
        if flag: continue
        visited.push_front(cur)
        # print(visited.size())

        for dir in DIRECTIONS:
            # if dir == cur.move.sign(): continue
            var cost := 0
            for i in range(1,4):
                var new_pos := cur.pos+(dir*i)
                if new_pos.x<0 or new_pos.y<0 or new_pos.x>=map[0].size() or new_pos.y>=map.size():
                    continue
                cost += get_cost(new_pos)
                var new := TreeNode.new(new_pos, dir*i, cur.dis + cost)
                new.is_valid = (cur.is_valid && dir != cur.move.sign())
                if new_pos == Vector2i(4,0):
                    print(new.pos, " ", new.move, " ", new.dis)
                queue.append(new)
                cur.next.append(new)

    for node in visited:
        map[node.pos.y][node.pos.x] = node.dis
        
    for node in visited:
        if node.pos == Vector2i(map[0].size()-1, map.size()-1):
            return node.dis
    return -1


func get_cost(pos:Vector2i) -> int:
    return map[pos.y][pos.x]


        