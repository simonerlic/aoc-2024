import Foundation

public class Day10: Day {
    private let input: String
    private var grid: [[Int]] = []
    private var rows = 0
    private var cols = 0

    required init() {
        self.input = FileReader.readInput(for: 10)
        parseInput()
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 10)
        parseInput()
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 10, type: .test))
    }

    private func parseInput() {
        grid = input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { line in
                line.compactMap { Int(String($0)) }
            }
        rows = grid.count
        cols = grid[0].count
    }

    private struct Position: Hashable {
        let row: Int
        let col: Int
    }

    private func getNeighbors(of pos: Position) -> [Position] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]  // right, down, left, up
        return directions.compactMap { dir in
            let newRow = pos.row + dir.0
            let newCol = pos.col + dir.1
            guard newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols else {
                return nil
            }
            return Position(row: newRow, col: newCol)
        }
    }

    private func findReachableNines(from start: Position) -> Int {
        var visited = Set<Position>()
        var reachableNines = Set<Position>()

        func dfs(_ pos: Position, currentHeight: Int) {
            guard !visited.contains(pos) else { return }
            visited.insert(pos)

            if grid[pos.row][pos.col] == 9 {
                reachableNines.insert(pos)
            }

            for neighbor in getNeighbors(of: pos) {
                let nextHeight = grid[neighbor.row][neighbor.col]
                if nextHeight == currentHeight + 1 {
                    dfs(neighbor, currentHeight: nextHeight)
                }
            }
        }

        dfs(start, currentHeight: 0)

        return reachableNines.count
    }

    private func findTrailheads() -> [Position] {
        var trailheads: [Position] = []

        for row in 0..<rows {
            for col in 0..<cols {
                if grid[row][col] == 0 {
                    trailheads.append(Position(row: row, col: col))
                }
            }
        }

        return trailheads
    }

    func solvePart1() -> String {
        let trailheads = findTrailheads()
        let totalScore = trailheads.reduce(0) { sum, trailhead in
            sum + findReachableNines(from: trailhead)
        }
        return String(totalScore)
    }

    private func countDistinctTrails(from start: Position) -> Int {
        var distinctPaths = 0
        var visited = Set<Position>()

        func dfs(_ pos: Position, currentHeight: Int) {
            if grid[pos.row][pos.col] == 9 {
                distinctPaths += 1
                return
            }

            visited.insert(pos)

            for neighbor in getNeighbors(of: pos) {
                let nextHeight = grid[neighbor.row][neighbor.col]
                if nextHeight == currentHeight + 1 {
                    if !visited.contains(neighbor) {
                        dfs(neighbor, currentHeight: nextHeight)
                    }
                }
            }
            visited.remove(pos)
        }

        // Start DFS from the trailhead
        dfs(start, currentHeight: 0)
        return distinctPaths
    }

    func solvePart2() -> String {
        let trailheads = findTrailheads()
        let totalRating = trailheads.reduce(0) { sum, trailhead in
            sum + countDistinctTrails(from: trailhead)
        }
        return String(totalRating)
    }
}
