import Foundation

public class Day07: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 7)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 7)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 7, type: .test))
    }

    func solvePart1() -> String {
        return solve(using: [(+), (*)])
    }

    func solvePart2() -> String {
        return solve(using: [(+), (*), { Int("\($0)\($1)")! }])
    }

    private func solve(using operators: [(Int, Int) -> Int]) -> String {
        let lines = input.split(separator: "\r\n")
        var totalCalibrationResult = 0

        for line in lines {
            let parts = line.split(separator: ":")
            let testValue = Int(parts[0].trimmingCharacters(in: .whitespaces))!
            let numbers = parts[1].split(separator: " ").compactMap { Int($0) }

            if canFormTestValue(testValue, with: numbers, using: operators) {
                totalCalibrationResult += testValue
            }
        }

        return String(totalCalibrationResult)
    }

    private func canFormTestValue(
        _ testValue: Int, with numbers: [Int], using operators: [(Int, Int) -> Int]
    ) -> Bool {
        let n = numbers.count

        func evaluate(_ expression: [(Int, (Int, Int) -> Int)]) -> Int {
            return expression.reduce(numbers[0]) { result, element in
                element.1(result, element.0)
            }
        }

        func generateExpressions(_ index: Int, _ current: [(Int, (Int, Int) -> Int)]) -> Bool {
            if index == n - 1 {
                return evaluate(current) == testValue
            }

            for op in operators {
                var newCurrent = current
                newCurrent.append((numbers[index + 1], op))
                if generateExpressions(index + 1, newCurrent) {
                    return true
                }
            }
            return false
        }

        return generateExpressions(0, [])
    }
}
