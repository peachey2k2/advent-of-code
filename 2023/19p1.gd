extends SceneTree

var input := ""

var workflows := {}
var inputs : Array[In] = []

class In:
    var x : int
    var m : int
    var a : int
    var s : int

    func _init(line : String):
        line = line.trim_prefix("{").trim_suffix("}")
        var parts := line.split(",")
        x = parts[0].to_int()
        m = parts[1].to_int()
        a = parts[2].to_int()
        s = parts[3].to_int()

class Workflow:
    var rules : Array[Rule]
    var default : String

    func _init(line : String):
        var rules_str := line.get_slice("{", 1).trim_suffix("}").split(",")
        for i in rules_str.size() - 1:
            rules.append(Rule.new(rules_str[i]))
        default = rules_str[-1]

class Rule:
    var name : String
    var val : int
    var bigger_than : bool
    var res : String

    func _init(line : String):
        if line.contains(">"):
            bigger_than = true
            name = line.get_slice(">", 0)
            val = line.get_slice(">", 1).get_slice(":", 0). to_int()
        else:
            bigger_than = false
            name = line.get_slice("<", 0)
            val = line.get_slice("<", 1).get_slice(":", 0). to_int()
        res = line.get_slice(":", 1)


func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", true)
    var separation := lines.find("")

    for i in separation-1:
        var wf_name = lines[i].get_slice("{", 0)
        workflows[wf_name] = Workflow.new(lines[i])
    
    for i in range(separation+1, lines.size()-1):
        if lines[i] != "":
            inputs.append(In.new(lines[i]))

    var sum := 0
    
    for i in inputs.size():
        if check(inputs[i], "in"):
            sum += inputs[i].x + inputs[i].m + inputs[i].a + inputs[i].s

    print(sum)


func check(inp:In, wf_name:String) -> bool:
    if wf_name == "A": return true
    if wf_name == "R": return false
    var wf:Workflow = workflows[wf_name]
    for rule in wf.rules:
        if rule.bigger_than:
            if inp.get(rule.name) > rule.val:
                return check(inp, rule.res)
        else:
            if inp.get(rule.name) < rule.val:
                return check(inp, rule.res)
    return check(inp, wf.default)
        

    
