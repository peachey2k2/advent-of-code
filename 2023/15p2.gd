extends SceneTree

var input := ""
var steps:Array[Step] = []
var boxes:Array[Array]

class Step:
    enum Op {ADD, REMOVE}
    var label:String
    var box:int
    var op:Op
    var focal:int

    func _init(word:String):
        if word.contains("="):
            op = Op.ADD
            var splitted := word.split("=")
            label = splitted[0]
            focal = splitted[1].to_int()
        else:
            op = Op.REMOVE
            var splitted := word.split("-")
            label = splitted[0]
        box = _run_hash(label)
    
    func _run_hash(word:String) -> int:
        var sum := 0
        for c in word.to_ascii_buffer():
            sum += c
            sum *= 17
            sum %= 256
        return sum


func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var words:PackedStringArray = input.strip_edges().split(",", false)

    for word in words:
        steps.append(Step.new(word))

    boxes.resize(256)
    for step in steps:
        match step.op:
            Step.Op.ADD:
                var flag := false
                for lens in boxes[step.box]:
                    if lens.label == step.label:
                        lens.focal = step.focal
                        flag = true
                        break
                if not flag:
                    boxes[step.box].append(step)
            Step.Op.REMOVE:
                for lens in boxes[step.box]:
                    if lens.label == step.label:
                        boxes[step.box].erase(lens)
                        break
    
    var sum := 0
    for i in boxes.size():
        for j in boxes[i].size():
            sum += (i+1) * (j+1) * boxes[i][j].focal
    
    print(sum)
