import Foundation

public class Day12: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 12)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 12)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 12, type: .test))
    }

    struct Point: Hashable {
        let x: Int
        let y: Int
    }

    class Region {
        var points: [Point]
        var minX: Int
        var maxX: Int
        var minY: Int
        var maxY: Int
        let type: Character
        let grid: [[Character]]

        init(type: Character, grid: [[Character]]) {
            self.points = []
            self.type = type
            self.grid = grid
            self.minX = Int.max
            self.maxX = Int.min
            self.minY = Int.max
            self.maxY = Int.min
        }

        var area: Int { points.count }

        func addPoint(_ x: Int, _ y: Int) {
            let point = Point(x: x, y: y)
            points.append(point)
            minX = min(minX, x)
            maxX = max(maxX, x)
            minY = min(minY, y)
            maxY = max(maxY, y)
        }

        lazy var perimeter: Int = {
            var count = 0
            let pointSet = Set(points)

            for point in points {
                let neighbors = [
                    Point(x: point.x + 1, y: point.y),
                    Point(x: point.x - 1, y: point.y),
                    Point(x: point.x, y: point.y + 1),
                    Point(x: point.x, y: point.y - 1),
                ]

                for neighbor in neighbors {
                    if !pointSet.contains(neighbor) {
                        count += 1
                    }
                }
            }
            return count
        }()

        lazy var sides: Int = {
            let pointSet = Set(points)
            var horizontalSides = Set<Int>()
            var verticalSides = Set<Int>()

            for point in points {
                let x = point.x
                let y = point.y

                if !pointSet.contains(Point(x: x, y: y - 1)) {
                    var startX = x
                    while startX > minX && pointSet.contains(Point(x: startX - 1, y: y))
                        && !pointSet.contains(Point(x: startX - 1, y: y - 1))
                    {
                        startX -= 1
                    }
                    horizontalSides.insert(y * 1_000_000 + startX)
                }

                if !pointSet.contains(Point(x: x, y: y + 1)) {
                    var startX = x
                    while startX > minX && pointSet.contains(Point(x: startX - 1, y: y))
                        && !pointSet.contains(Point(x: startX - 1, y: y + 1))
                    {
                        startX -= 1
                    }
                    horizontalSides.insert((y + 1) * 1_000_000 + startX)
                }

                if !pointSet.contains(Point(x: x - 1, y: y)) {
                    var startY = y
                    while startY > minY && pointSet.contains(Point(x: x, y: startY - 1))
                        && !pointSet.contains(Point(x: x - 1, y: startY - 1))
                    {
                        startY -= 1
                    }
                    verticalSides.insert(x * 1_000_000 + startY)
                }

                if !pointSet.contains(Point(x: x + 1, y: y)) {
                    var startY = y
                    while startY > minY && pointSet.contains(Point(x: x, y: startY - 1))
                        && !pointSet.contains(Point(x: x + 1, y: startY - 1))
                    {
                        startY -= 1
                    }
                    verticalSides.insert((x + 1) * 1_000_000 + startY)
                }
            }

            return horizontalSides.count + verticalSides.count
        }()
    }

    private func findRegions(in grid: [[Character]]) -> [Region] {
        let height = grid.count
        let width = grid[0].count
        var visited = Array(repeating: Array(repeating: false, count: width), count: height)
        var regions: [Region] = []

        func floodFill(_ startX: Int, _ startY: Int, _ type: Character) -> Region {
            let region = Region(type: type, grid: grid)
            var queue = [(x: Int, y: Int)]()
            queue.append((startX, startY))
            var queueIndex = 0

            while queueIndex < queue.count {
                let (x, y) = queue[queueIndex]
                queueIndex += 1

                if !visited[y][x] && grid[y][x] == type {
                    visited[y][x] = true
                    region.addPoint(x, y)

                    if x > 0 { queue.append((x - 1, y)) }
                    if x < width - 1 { queue.append((x + 1, y)) }
                    if y > 0 { queue.append((x, y - 1)) }
                    if y < height - 1 { queue.append((x, y + 1)) }
                }
            }

            return region
        }

        for y in 0..<height {
            for x in 0..<width {
                if !visited[y][x] {
                    let region = floodFill(x, y, grid[y][x])
                    regions.append(region)
                }
            }
        }

        return regions
    }

    func solvePart1() -> String {
        let grid = input.split { $0.isNewline }.map { Array($0) }
        let regions = findRegions(in: grid)
        let totalPrice = regions.reduce(0) { $0 + $1.area * $1.perimeter }
        return String(totalPrice)
    }

    func solvePart2() -> String {
        let grid = input.split { $0.isNewline }.map { Array($0) }
        let regions = findRegions(in: grid)
        let totalPrice = regions.reduce(0) { $0 + $1.area * $1.sides }
        return String(totalPrice)
    }
}
