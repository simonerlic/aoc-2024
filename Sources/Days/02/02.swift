import Foundation

public class Day02: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 2)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 2)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 2, type: .test))
    }

    func solvePart1() -> String {
        var sum = 0
        let lines = input.split(separator: "\r\n")

        for line in lines {
            let levels = line.split(separator: " ").compactMap { Int($0) }
            print(levels)
            if isSafe(levels: levels) {
                sum += 1
            }
        }

        return String(sum)
    }

    func solvePart2() -> String {
        var sum = 0
        let lines = input.split(separator: "\r\n")

        for line in lines {
            let levels = line.split(separator: " ").compactMap { Int($0) }
            if isSafe(levels: levels) || dampenerCheck(levels: levels) {
                sum += 1
            }
        }

        return String(sum)
    }

    func isSafe(levels: [Int]) -> Bool {
        guard levels.count > 1 else { return true }

        var isIncreasing: Bool? = nil
        for i in 1..<levels.count {
            let diff = levels[i] - levels[i - 1]
            if diff == 0 || abs(diff) > 3 {
                return false
            }
            if isIncreasing == nil {
                isIncreasing = diff > 0
            } else if (isIncreasing! && diff < 0) || (!isIncreasing! && diff > 0) {
                return false
            }
        }

        return true
    }

    func dampenerCheck(levels: [Int]) -> Bool {
        for i in 0..<levels.count {
            var modifiedLevels = levels
            modifiedLevels.remove(at: i)
            if isSafe(levels: modifiedLevels) {
                return true
            }
        }
        return false
    }
}
