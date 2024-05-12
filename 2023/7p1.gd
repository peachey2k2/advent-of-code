extends SceneTree

var input := ""

var hands:Array[Hand]

class Hand:
    var hand:Array
    var bid:int

    var type:Type

    enum Type{
        HIGH_CARD,
        ONE_PAIR,
        TWO_PAIR,
        THREE_OF_A_KIND,
        FULL_HOUSE,
        FOUR_OF_A_KIND,
        FIVE_OF_A_KIND,
    }

    func _init(line:String):
        var splitted := line.split(" ")
        bid = splitted[1].to_int()
        for c in splitted[0]:
            var value:int
            match c:
                "A": value = 14
                "K": value = 13
                "Q": value = 12
                "J": value = 11
                "T": value = 10
                _: value = c.to_int()
            hand.append(value)

        _calculate_type()
        

    func _calculate_type():
        var counter:Dictionary = {}
        for card in hand:
            counter[card] = counter[card]+1 if counter.keys().has(card) else 1
        var counts := counter.values()
        if counts.has(5):
            type = Type.FIVE_OF_A_KIND
        elif counts.has(4):
            type = Type.FOUR_OF_A_KIND
        elif counts.has(3):
            if counts.has(2):
                type = Type.FULL_HOUSE
            else:
                type = Type.THREE_OF_A_KIND
        elif counts.has(2):
            if counts.size() == 3:
                type = Type.TWO_PAIR
            else:
                type = Type.ONE_PAIR
        else:
            type = Type.HIGH_CARD


func _init():
    input = await ResourceLoader.load("res://../input_fetcher.gd").new().get_input(self)
    main()
    quit()

func main():
    var lines := input.split("\n", false)
    for line in lines:
        hands.append(Hand.new(line))
    
    hands.sort_custom(func(a:Hand, b:Hand):
        if a.type < b.type:
            return true
        elif b.type < a.type:
            return false
        else:
            for i in 5:
                if a.hand[i] < b.hand[i]:
                    return true
                elif b.hand[i] < a.hand[i]:
                    return false
        # printerr("same hand is played twice: ", a.hand, " = ", b.hand, "\nbids: ", a.bid, ", ", b.bid)
        return true # why does the question not mention this grrrr
    )

    var out := 0
    for i in hands.size():
        out += (i+1) * hands[i].bid
    print(out)

