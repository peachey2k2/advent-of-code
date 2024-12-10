import System.IO
import Control.Monad (forM_)
import qualified Data.HashSet as HashSet

main = do
    file <- readFile "../input.txt"
    let input_str = lines file
    let input = map (map (\c -> read [c] :: Int)) input_str
    let results = [HashSet.size $ go input (x, y) 0 | (y, line) <- zip [0..] input, (x, c) <- filter (\(_, c) -> c == 0) (zip [0..] line)]
    print $ sum results
    
go :: [[Int]] -> (Int, Int) -> Int -> HashSet.HashSet (Int, Int)
go input (x, y) cur
    | x < 0 || x >= length (head input) || y < 0 || y >= length (head input) = HashSet.empty
    | (input!!y)!!x /= cur = HashSet.empty
    | cur == 9 = HashSet.fromList [(x, y)]
    | otherwise = HashSet.unions [
        go input (x+1, y) (cur+1),
        go input (x-1, y) (cur+1),
        go input (x, y+1) (cur+1),
        go input (x, y-1) (cur+1)
    ]