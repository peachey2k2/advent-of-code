extends SceneTree

var input := ""

var rows:Array[Row] = []

class Row:
    var seq:String
    var nums:Array[int]
    var possibilities:int = 0

    func _init(line:String):
        var s := line.split(" ")
        seq = s[0]
        s = s[1].split(",")
        for num in s:
            nums.append(num.to_int())
        
        while seq.begins_with("#") and seq[nums[0]] != "#":
            seq = seq.right(-nums.pop_front()-1)
        
        while seq.ends_with("#") and seq[-nums[-1]-1] != "#":
            seq = seq.left(-nums.pop_back()-1)
        
        _permutate()
    
    func _permutate():
        var permutations:Array[String] = [seq]

        for i in seq.length():
            if seq[i] == "?":
                var new_perms:Array[String] = []
                for p in permutations:
                    for ch in ["#", "."]:
                        var s := p
                        s[i] = ch
                        new_perms.append(s)
                permutations = new_perms
        
        for p in permutations:
            if _validate(p):
                possibilities += 1
    
    func _validate(s:String) -> bool:
        var idx := 0
        s += "."
        for num in nums:
            while s[idx] == ".":
                idx += 1
                if idx >= s.length(): return false
            for i in num:
                if s[idx] == ".": return false
                idx += 1
                if idx >= s.length(): return false
            if s[idx] == "#": return false
        if s.right(-idx).contains("#"):
            return false
        var sum := 0
        for num in nums: sum += num
        if s.count("#") != sum: return false 
        return true

                
    
    func _to_string():
        return seq + " " + str(nums) + "(" + str(possibilities) + ")"


func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    for line in lines:
        rows.append(Row.new(line))
    
    var sum := 0
    for row in rows:
        sum += row.possibilities
    
    print(sum)
