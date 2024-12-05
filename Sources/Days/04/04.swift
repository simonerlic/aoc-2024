import Foundation

public class Day04: Day {
    private let input: String
    private let inputType: FileReader.InputType

    required init() {
        self.inputType = .input
        self.input = FileReader.readInput(for: 4, type: self.inputType)
    }

    required init(input: String? = nil, type: FileReader.InputType = .input) {
        self.inputType = type
        self.input = input ?? FileReader.readInput(for: 4, type: self.inputType)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 4, type: .test), type: .test)
    }

    func solvePart1() -> String {
        let grid = input.split { $0.isNewline }.map { Array($0) }
        let word = "XMAS"
        let wordLength = word.count
        let directions = [
            (0, 1),  // right
            (1, 0),  // down
            (1, 1),  // down-right
            (1, -1),  // down-left
            (0, -1),  // left
            (-1, 0),  // up
            (-1, -1),  // up-left
            (-1, 1),  // up-right
        ]

        func isValid(x: Int, y: Int, dx: Int, dy: Int) -> Bool {
            for i in 0..<wordLength {
                let nx = x + i * dx
                let ny = y + i * dy
                if nx < 0 || ny < 0 || nx >= grid.count || ny >= grid[0].count
                    || grid[nx][ny] != Array(word)[i]
                {
                    return false
                }
            }
            return true
        }

        var count = 0
        for x in 0..<grid.count {
            for y in 0..<grid[0].count {
                for (dx, dy) in directions {
                    if isValid(x: x, y: y, dx: dx, dy: dy) {
                        count += 1
                    }
                }
            }
        }

        return String(count)
    }

    // my test runner was broken, so I spent like 20 minutes figuring out why this wasn't working
    // literally rewrote the whole thing and then realized it was the test runner that was broken
    func solvePart2() -> String {
        let grid = input.split { $0.isNewline }.map { Array($0) }
        var count = 0

        for row in 0..<grid.count {
            for col in 0..<grid[0].count {
                if grid[row][col] == "A" {
                    if row - 1 >= 0 && col - 1 >= 0 && row + 1 < grid.count
                        && col + 1 < grid[0].count
                    {

                        let topLeft = grid[row - 1][col - 1]
                        let topRight = grid[row - 1][col + 1]
                        let bottomLeft = grid[row + 1][col - 1]
                        let bottomRight = grid[row + 1][col + 1]

                        // Check diagonal from top-left to bottom-right
                        let rightValid =
                            (topLeft == "M" && bottomRight == "S")
                            || (topLeft == "S" && bottomRight == "M")

                        // Check diagonal from top-right to bottom-left
                        let leftValid =
                            (topRight == "M" && bottomLeft == "S")
                            || (topRight == "S" && bottomLeft == "M")

                        // If both diagonals are valid, we found an X-MAS
                        if rightValid && leftValid {
                            print("Incrementing count at \(row), \(col)")
                            count += 1
                        }
                    }
                }
            }
        }

        return String(count)
    }
}
