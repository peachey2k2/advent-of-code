use std::fs;
use std::ops;
use std::cmp;

#[derive(Debug, PartialEq, Clone, Copy)]
struct Coord {
    x: i32,
    y: i32,
}

impl ops::Add for Coord {
    type Output = Coord;

    fn add(self, other: Coord) -> Self::Output {
        Coord {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

impl ops::Mul<i32> for Coord {
    type Output = Coord;

    fn mul(self, other: i32) -> Self::Output {
        Coord {
            x: self.x * other,
            y: self.y * other,
        }
    }
}

impl Eq for Coord {}

impl PartialOrd for Coord {
    fn partial_cmp(&self, other: &Self) -> Option<cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Coord {
    fn cmp(&self, other: &Self) -> cmp::Ordering {
        let cmp_y = self.y.cmp(&other.y);
        if cmp_y == cmp::Ordering::Equal {
            return self.x.cmp(&other.x);
        }
        cmp_y
    }
}

impl Coord {
    const fn new(x: i32, y: i32) -> Coord {
        Coord {x: x, y: y}
    }
    
    pub const UP:    Self = Coord::new( 0, -1);
    pub const DOWN:  Self = Coord::new( 0,  1);
    pub const LEFT:  Self = Coord::new(-1,  0);
    pub const RIGHT: Self = Coord::new( 1,  0);
}

const WIDTH: usize = 100;
const HEIGHT: usize = 50;

fn main() -> Result<(), String> {
    let mut board: [[u8; WIDTH]; HEIGHT] = [[b'.'; WIDTH]; HEIGHT];
    let mut pos = Coord::new(0, 0);
    let input = fs::read_to_string("../input.txt").unwrap();
    for (i, part) in input.split("\n\n").enumerate() {
        match i {
            0 => for (y, line) in part.lines().enumerate() {
                for (x, c) in line.chars().enumerate() {
                    board[y][2*x] = c as u8;
                    match c as u8 {
                        b'#' => board[y][2*x + 1] = b'#',
                        b'@' => {
                            pos = Coord::new(2*x as i32, y as i32);
                            board[y][2*x] = b'.'
                        },
                        _    => {},
                    }
                }
            },
            1 => move_robot(pos, &mut board, part.as_bytes())?,
            _ => return Err("unreachable".to_string()),
        }
    }

    let mut weights = [[0u32; WIDTH]; HEIGHT];
    for y in 1..(HEIGHT-1) {
        for x in 1..(WIDTH-1) {
            weights[y][x] = (100 * y + x) as u32;
        }
    }
    let sum: u32 = board.iter().zip(weights.iter()).map(|(line, weight_line)| 
        line.iter().zip(weight_line.iter()).filter(|(&c, _)| c == b'O').map(|(_, &w)| w).sum::<u32>()
    ).sum();
    println!("{}", sum);
    // println!("took {:?}", start.elapsed());

    Ok(())
}

fn move_robot(pos: Coord, board: &mut [[u8; WIDTH]; HEIGHT], moves: &[u8]) -> Result<(), String>{
    let mut cur_pos = pos;
    for m in moves {
        cur_pos = cur_pos + match m {
            b'^' => {
                let target = cur_pos + Coord::UP;
                if get_at(board, target) == b'#' {continue;}
                if !recursive_push(board, target, Coord::UP) {continue;}
                Coord::UP
            },
            b'v' => {
                let target = cur_pos + Coord::DOWN;
                if get_at(board, target) == b'#' {continue;}
                if !recursive_push(board, target, Coord::DOWN) {continue;}
                Coord::DOWN
            },
            b'<' => {
                let mut check = cur_pos + Coord::LEFT*2;
                let target = cur_pos + Coord::LEFT;
                let mut o_count = 0;
                if get_at(board, target) == b'#' {continue;}
                while get_at(board, check) == b'O' {
                    check = check + Coord::LEFT*2;
                    o_count += 1;
                }
                if get_at(board, check + Coord::RIGHT) == b'#' {continue;}
                for _ in 0..o_count {
                    check = check + Coord::RIGHT*2;
                    swap(board, check, check + Coord::LEFT);
                }
                Coord::LEFT
            },
            b'>' => {
                let mut check = cur_pos + Coord::RIGHT;
                let target = cur_pos + Coord::RIGHT;
                let mut o_count = 0;
                if get_at(board, target) == b'#' {continue;}
                while get_at(board, check) == b'O' {
                    check = check + Coord::RIGHT*2;
                    o_count += 1;
                }
                if get_at(board, check) == b'#' {continue;}
                for _ in 0..o_count {
                    check = check + Coord::LEFT*2;
                    swap(board, check, check + Coord::RIGHT);
                }
                Coord::RIGHT
            },
            _    => {continue;},
        };
    }
    Ok(())
}

#[inline(always)]
fn get_at(board: &[[u8; WIDTH]; HEIGHT], at: Coord) -> u8 {
    board[at.y as usize][at.x as usize]
}

#[inline(always)]
fn swap(board: &mut [[u8; WIDTH]; HEIGHT], a: Coord, b: Coord) {
    let temp = board[a.y as usize][a.x as usize];
    board[a.y as usize][a.x as usize] = board[b.y as usize][b.x as usize];
    board[b.y as usize][b.x as usize] = temp;
}

fn recursive_push(board: &mut [[u8; WIDTH]; HEIGHT], start: Coord, dir: Coord) -> bool {
    let res = if get_at(board, start) == b'O' {
        check_next(board, start, dir)
    } else if get_at(board, start + Coord::LEFT) == b'O' {
        check_next(board, start + Coord::LEFT, dir)
    } else {return true};

    if let Some(mut list) = res {
        list.sort_unstable();
        if dir == Coord::DOWN {list.reverse();}
        for (i, b) in list.iter().enumerate() {
            if i == 0 || list[i-1] != *b {
                swap(board, *b, *b + dir);
            } 
        }
        return true;
    } else {
        return false;
    }
}

fn check_next(board: &mut [[u8; WIDTH]; HEIGHT], check: Coord, dir: Coord) -> Option<Vec<Coord>> {
    let nexts = [
        get_at(board, check + Coord::LEFT),
        get_at(board, check),
        get_at(board, check + Coord::RIGHT),
    ];
    let mut list = Vec::<Coord>::new();
    if nexts[1] == b'#' || nexts[2] == b'#' {
        return None;
    }
    
    if nexts[0] == b'O' {
        if !list.contains(&(check + Coord::LEFT)) {list.push(check + Coord::LEFT);}
        let res = check_next(board, check + dir + Coord::LEFT, dir)?;
        list.extend(res);
    }
    if nexts[1] == b'O' {
        if !list.contains(&(check)) {list.push(check);}
        let res = check_next(board, check + dir, dir)?;
        list.extend(res);
    }
    if nexts[2] == b'O' {
        if !list.contains(&(check + Coord::RIGHT)) {list.push(check + Coord::RIGHT);}
        let res = check_next(board, check + dir + Coord::RIGHT, dir)?;
        list.extend(res);
    }

    return Some(list);
}


