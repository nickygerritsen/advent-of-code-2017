import Foundation

func printGrid(grid: [[Int]]) {
    for x in grid.indices {
        for y in grid[x].indices {
            if (grid[x][y] == -1) {
                print("   ", separator: "", terminator: "")
            } else {
                print(String(format: "%3d", grid[x][y]), separator: "", terminator: "")
            }
            print(" ", separator: "", terminator: "")
        }
        print("")
    }
}

func neighborSum(grid: [[Int]], x: Int, y: Int) -> Int {
    var sum = 0
    for xd in [-1, 0, 1] {
        for yd in [-1, 0, 1] {
            if xd != 0 || yd != 0 {
                let gridValue = grid[y+yd][x+xd]
                if gridValue != -1 {
                    sum += gridValue
                }
            }
        }
    }
    
    return sum
}

let input = 325489

var sz = Int(ceil(Double(input) / 2))
var center = Int(ceil(Double(sz) / 2))

let row = [Int](repeating: -1, count: sz)
var grid = [[Int]](repeating: row, count: sz)
var grid2 = [[Int]](repeating: row, count: sz)
let directions = [
    (-1, 0),
    (0, -1),
    (1, 0),
    (0, 1)
]
var currentDirection = 1
var previousDirection = 0

grid[center][center] = 1
grid[center][center+1] = 2
grid2[center][center] = 1
grid2[center][center+1] = 1

var posX = center+1
var posY = center
var curNum = 3
var partTwoDone = false

while grid[posY][posX] != input {
    // First, see if we can go in the desired direction
    let newX = posX + directions[currentDirection].1
    let newY = posY + directions[currentDirection].0
    
    if grid[newY][newX] == -1 {
        // We can go there, turn direction
        currentDirection = (currentDirection + 1) % 4
        previousDirection = (previousDirection + 1) % 4
        posX = newX
        posY = newY
    } else {
        posX = posX + directions[previousDirection].1
        posY = posY + directions[previousDirection].0
    }
    
    grid[posY][posX] = curNum
    if !partTwoDone { // Stop early because this runs out of the integer space pretty fast
        grid2[posY][posX] = neighborSum(grid: grid2, x: posX, y: posY)
        if grid2[posY][posX] > input {
            print("Solution for part 2:", grid2[posY][posX])
            partTwoDone = true
        }
    }
    curNum += 1
}

let distance = abs(posX - center) + abs(posY - center)

print("Solution for part 1:", distance)
