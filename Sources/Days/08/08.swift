import Foundation

public class Day08: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 8)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 8)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 8, type: .test))
    }

    struct Point: Hashable {
        let x: Int
        let y: Int
    }

    // Helper function to check if three points are collinear
    func areCollinear(_ p1: Point, _ p2: Point, _ p3: Point) -> Bool {
        let area = p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y)
        return area == 0
    }

    // Helper function to parse input and group antennas by frequency
    func parseInput(_ input: String) -> (
        width: Int, height: Int, antennasByFreq: [Character: [Point]]
    ) {
        let lines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let height = lines.count
        let width = lines[0].count

        var antennasByFreq: [Character: [Point]] = [:]

        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                if char != "." {
                    antennasByFreq[char, default: []].append(Point(x: x, y: y))
                }
            }
        }

        return (width, height, antennasByFreq)
    }

    func solvePart1() -> String {
        let (width, height, antennasByFreq) = parseInput(input)
        var antinodes = Set<Point>()

        for (_, antennas) in antennasByFreq {
            guard antennas.count >= 2 else { continue }

            for i in 0..<antennas.count {
                for j in (i + 1)..<antennas.count {
                    let a1 = antennas[i]
                    let a2 = antennas[j]

                    let dx = a2.x - a1.x
                    let dy = a2.y - a1.y

                    let antinode1 = Point(x: a2.x + dx, y: a2.y + dy)
                    let antinode2 = Point(x: a1.x - dx, y: a1.y - dy)

                    if antinode1.x >= 0 && antinode1.x < width && antinode1.y >= 0
                        && antinode1.y < height
                    {
                        antinodes.insert(antinode1)
                    }

                    if antinode2.x >= 0 && antinode2.x < width && antinode2.y >= 0
                        && antinode2.y < height
                    {
                        antinodes.insert(antinode2)
                    }
                }
            }
        }

        return String(antinodes.count)
    }

    func solvePart2() -> String {
        let (width, height, antennasByFreq) = parseInput(input)
        var antinodes = Set<Point>()

        // For each frequency group
        for (_, antennas) in antennasByFreq {
            guard antennas.count >= 2 else { continue }

            // Check every point in the grid
            for y in 0..<height {
                for x in 0..<width {
                    let point = Point(x: x, y: y)

                    // Count how many antenna pairs this point is collinear with
                    for i in 0..<antennas.count {
                        for j in (i + 1)..<antennas.count {
                            if areCollinear(antennas[i], antennas[j], point) {
                                antinodes.insert(point)
                                break  // No need to check more pairs once we find one
                            }
                        }
                    }
                }
            }
        }

        return String(antinodes.count)
    }
}
