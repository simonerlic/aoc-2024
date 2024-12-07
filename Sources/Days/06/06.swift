import Foundation

public class Day06: Day {
    private let input: String

    private enum Direction {
        case up, right, down, left

        func turnRight() -> Direction {
            switch self {
            case .up: return .right
            case .right: return .down
            case .down: return .left
            case .left: return .up
            }
        }

        func nextPosition(from current: (x: Int, y: Int)) -> (x: Int, y: Int) {
            switch self {
            case .up: return (current.x, current.y - 1)
            case .right: return (current.x + 1, current.y)
            case .down: return (current.x, current.y + 1)
            case .left: return (current.x - 1, current.y)
            }
        }
    }

    required init() {
        self.input = FileReader.readInput(for: 6)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 6)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 6, type: .test))
    }

    private func parseInput() -> (
        grid: [[Character]], start: (x: Int, y: Int), direction: Direction
    ) {
        let lines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        var grid = lines.map { Array($0) }

        for (y, row) in grid.enumerated() {
            if let x = row.firstIndex(of: "^") {
                grid[y][x] = "."
                return (grid, (x, y), .up)
            }
        }

        return (grid, (0, 0), .up)
    }

    private func isWithinBounds(_ pos: (x: Int, y: Int), grid: [[Character]]) -> Bool {
        pos.y >= 0 && pos.y < grid.count && pos.x >= 0 && pos.x < grid[0].count
    }

    func solvePart1() -> String {
        let (grid, startPos, initialDirection) = parseInput()
        var visited = Set<String>()
        var currentPos = startPos
        var currentDirection = initialDirection

        visited.insert("\(currentPos.x),\(currentPos.y)")

        while true {
            let nextPos = currentDirection.nextPosition(from: currentPos)
            guard isWithinBounds(nextPos, grid: grid) else { break }

            if grid[nextPos.y][nextPos.x] == "#" {
                currentDirection = currentDirection.turnRight()
            } else {
                currentPos = nextPos
                visited.insert("\(currentPos.x),\(currentPos.y)")
            }
        }

        return "\(visited.count)"
    }

    func solvePart2() -> String {
        let (grid, startPos, initialDirection) = parseInput()
        var validPositions = 0

        for y in 0..<grid.count {
            for x in 0..<grid[0].count {
                let isValidPosition = grid[y][x] != "#" && (x != startPos.x || y != startPos.y)
                if isValidPosition
                    && simulatePathWithObstruction(
                        grid: grid,
                        startPos: startPos,
                        initialDirection: initialDirection,
                        obstruction: (x, y)
                    )
                {
                    validPositions += 1
                }
            }
        }

        return "\(validPositions)"
    }

    private func simulatePathWithObstruction(
        grid: [[Character]],
        startPos: (x: Int, y: Int),
        initialDirection: Direction,
        obstruction: (x: Int, y: Int)
    ) -> Bool {
        var currentGrid = grid
        currentGrid[obstruction.y][obstruction.x] = "#"

        var currentPos = startPos
        var currentDirection = initialDirection
        var stateHistory = Set<String>()
        var steps = 0
        let maxSteps = grid.count * grid[0].count * 4

        while steps < maxSteps {
            steps += 1
            let state = "\(currentPos.x),\(currentPos.y),\(currentDirection)"

            if stateHistory.contains(state) {
                return stateHistory.count > 4
            }
            stateHistory.insert(state)

            let nextPos = currentDirection.nextPosition(from: currentPos)
            guard isWithinBounds(nextPos, grid: currentGrid) else { return false }

            if currentGrid[nextPos.y][nextPos.x] == "#" {
                currentDirection = currentDirection.turnRight()
            } else {
                currentPos = nextPos
            }
        }

        return false
    }
}
