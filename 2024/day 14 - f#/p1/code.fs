module AdventOfCode.Day14

open System
open System.Collections.Generic
open System.IO
open System.Text.RegularExpressions


type Coord = {
    x: int
    y: int
}

type Robot = {
    pos: Coord
    vel: Coord
}

let STEP_COUNT = 100
let DIMS = {x = 101; y = 103}
let MID = {x = DIMS.x / 2; y = DIMS.y / 2}

let robots = ResizeArray<Robot>()

let reader = new StreamReader("../input.txt")
while not reader.EndOfStream do
    let line = reader.ReadLine()
    let matches = Regex.Match(line, @"p\=(\d+)\,(\d+) v\=(\-?\d+)\,(\-?\d+)")
    if matches.Success then
        let pos = {x = int matches.Groups.[1].Value; y = int matches.Groups.[2].Value}
        let vel = {x = int matches.Groups.[3].Value; y = int matches.Groups.[4].Value}
        robots.Add({pos = pos; vel = vel})
    else
        printfn "regex error"
reader.Close()

let modulo (a: int) (b: int) : int =
    let rem = a % b
    if (rem >= 0) then rem else (rem + abs b)

let quads = Array.zeroCreate<int> 4
for rob in robots do
    let newPos = (
        (modulo (rob.pos.x + rob.vel.x * STEP_COUNT) DIMS.x),
        (modulo (rob.pos.y + rob.vel.y * STEP_COUNT) DIMS.y)
    )
    match newPos with
    | (x, y) when (x < MID.x && y < MID.y) -> quads.[0] <- quads.[0] + 1
    | (x, y) when (x < MID.x && y > MID.y) -> quads.[1] <- quads.[1] + 1
    | (x, y) when (x > MID.x && y < MID.y) -> quads.[2] <- quads.[2] + 1
    | (x, y) when (x > MID.x && y > MID.y) -> quads.[3] <- quads.[3] + 1
    | _ -> ()

printfn "%d" (quads.[0] * quads.[1] * quads.[2] * quads.[3])


