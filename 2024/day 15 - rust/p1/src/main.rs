use std::fs;
use std::ops;


#[derive(Debug, PartialEq, Clone, Copy)]
struct Coord {
    x: i32,
    y: i32,
}

impl ops::Add for Coord {
    type Output = Coord;

    fn add(self, other: Coord) -> Coord {
        Coord {
            x: self.x + other.x,
            y: self.y + other.y,
        }
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

fn main() -> Result<(), String> {
    let mut board: [[u8; 50]; 50] = [[b' '; 50]; 50];
    let mut pos = Coord::new(0, 0);
    let input = fs::read_to_string("../input.txt").unwrap();
    for (i, part) in input.split("\n\n").enumerate() {
        match i {
            0 => for (y, line) in part.lines().enumerate() {
                board[y][..50].copy_from_slice(line.as_bytes());
                if let Some(x) = line.find("@") {
                    pos = Coord::new(x as i32, y as i32);
                    board[y][x] = b'.';
                }
            },
            1 => move_robot(pos, &mut board, part.as_bytes())?,
            _ => return Err("unreachable".to_string()),
        }
    }

    let mut weights = [[0u32; 50]; 50];
    for y in 1..49 {
        for x in 1..49 {
            weights[y][x] = (100 * y + x) as u32;
        }
    }
    let sum: u32 = board.iter().zip(weights.iter()).map(|(line, weight_line)| 
        line.iter().zip(weight_line.iter()).filter(|(&c, _)| c == b'O').map(|(_, &w)| w).sum::<u32>()
    ).sum();
    println!("{}", sum);

    Ok(())
}

fn move_robot(pos: Coord, board: &mut [[u8; 50]; 50], moves: &[u8]) -> Result<(), String>{
    let mut cur_pos = pos;
    for m in moves {
        let dir = match m {
            b'^' => Coord::UP,
            b'v' => Coord::DOWN,
            b'<' => Coord::LEFT,
            b'>' => Coord::RIGHT,
            _    => {continue;}
        };
        let mut check = cur_pos + dir;
        let target = check;
        loop {
            let c = get_at(&board, check);
            match c {
                b'#' => break,
                b'.' => {
                    swap(board, check, target);
                    cur_pos = target;
                    break;
                }, 
                b'O' => {check = check + dir;},
                _    => return Err("unreachable".to_string()),
            }
        }
    }
    Ok(())
}

#[inline(always)]
fn get_at(board: &[[u8; 50]; 50], at: Coord) -> u8 {
    board[at.y as usize][at.x as usize]
}

#[inline(always)]
fn swap(board: &mut [[u8; 50]; 50], a: Coord, b: Coord) {
    let temp = board[a.y as usize][a.x as usize];
    board[a.y as usize][a.x as usize] = board[b.y as usize][b.x as usize];
    board[b.y as usize][b.x as usize] = temp;
}

