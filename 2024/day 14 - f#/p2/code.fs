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

let DIMS = {x = 101; y = 103}

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

// let quads = Array.zeroCreate<String> 4

for turn in 1 .. 12345 do
    let xMap = Array.zeroCreate<int> DIMS.x
    let yMap = Array.zeroCreate<int> DIMS.y

    for i in 0 .. robots.Count-1 do
        let newPos = {
            x = (modulo (robots.[i].pos.x + robots.[i].vel.x) DIMS.x);
            y = (modulo (robots.[i].pos.y + robots.[i].vel.y) DIMS.y)
        }
        robots.[i] <- {pos = newPos; vel = robots.[i].vel}

        xMap.[newPos.x] <- xMap.[newPos.x] + 1
        yMap.[newPos.y] <- yMap.[newPos.y] + 1

    let frame = seq {
        for n in xMap do
            if n > 30 then yield n
        for n in yMap do
            if n > 30 then yield n
    }

    if frame |> Seq.length >= 4 then
        printfn "%d" turn

        



