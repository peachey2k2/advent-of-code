import System.IO
import Control.Monad (forM_)

main = do
    file <- readFile "../input.txt"
    let input_str = lines file
    let input = map (map (\c -> read [c] :: Int)) input_str
    let results = [go input (x, y) 0 | (y, line) <- zip [0..] input, (x, c) <- filter (\(_, c) -> c == 0) (zip [0..] line)]
    print $ sum results
    
go :: [[Int]] -> (Int, Int) -> Int -> Int
go input (x, y) cur
    | x < 0 || x >= length (head input) || y < 0 || y >= length (head input) = 0
    | (input!!y)!!x /= cur = 0
    | cur == 9 = 1
    | otherwise =
        go input (x+1, y) (cur+1) +
        go input (x-1, y) (cur+1) +
        go input (x, y+1) (cur+1) +
        go input (x, y-1) (cur+1)
    