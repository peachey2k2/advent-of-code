import os

struct PageRule {
    before int
    after int
}

fn main() {
    input := os.read_lines("../input.txt") or {
        eprintln("file reading error")
        exit(1)
    }

    mut rules := []PageRule{}
    mut updates := [][]int{}

    for i, line in input {
        if line.len == 0 {
            for j in (i+1)..input.len {
                updates << input[j].split(',').map(it.int())
            }
            break
        }
        rules << (PageRule{
            line.all_before('|').int(),
            line.all_after('|').int(),
        })
    }

    mut sum := 0

    for cur_update in updates {
        mut valid := true
        for cur_rule in rules {
            idx1 := cur_update.index(cur_rule.before)
            idx2 := cur_update.index(cur_rule.after)
            if idx1 != -1 && idx2 != -1 {
                if idx1 > idx2 {
                    valid = false
                    break
                }
            }
        }
        if valid {
            sum += cur_update[cur_update.len / 2]
        }
    }

    println(sum)
}
