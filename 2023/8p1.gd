extends SceneTree

var input := ""

var nodes:Dictionary
var insts:String
var idx:int = 0
var cur_node:String = "AAA"

func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    insts = lines[0]

    var regex = RegEx.new()
    regex.compile("(?<a>[A-Z]+) = \\((?<b>[A-Z]+), (?<c>[A-Z]+)\\)")
    for i in range(2, lines.size()):
        var res := regex.search(lines[i])
        nodes[res.get_string("a")] = [res.get_string("b"), res.get_string("c")]
    
    while cur_node != "ZZZ":
        if insts[idx % insts.length()] == "L":
            cur_node = nodes[cur_node][0]
        else:
            cur_node = nodes[cur_node][1]
        idx += 1
    
    print(idx) # ez
    
