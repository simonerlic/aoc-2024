import Foundation

public class Day05: Day {
    private let input: String
    private let inputType: FileReader.InputType

    required init() {
        self.inputType = .input
        self.input = FileReader.readInput(for: 5, type: self.inputType)
    }

    required init(input: String? = nil, type: FileReader.InputType = .input) {
        self.inputType = type
        self.input = input ?? FileReader.readInput(for: 5, type: self.inputType)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 5, type: .test), type: .test)
    }

    private func parseInput() -> (rules: [[String]], pages: [[String]]) {
        let components = input.split(separator: "\r\n\r\n")
        guard components.count >= 2 else { return ([], []) }

        let rules = components[0].split(separator: "\r\n").map {
            $0.split(separator: "|").map(String.init)
        }
        let pages = components[1].split(separator: "\r\n").map {
            $0.split(separator: ",").map(String.init)
        }

        return (rules, pages)
    }

    func solvePart1() -> String {
        let (rules, pages) = parseInput()
        var result: [Int] = []

        for line in pages {
            var rightOrder = true

            for rule in rules {
                guard rule.count >= 2,
                    let num1 = line.firstIndex(of: rule[0]),
                    let num2 = line.firstIndex(of: rule[1])
                else {
                    continue
                }

                if num1 > num2 {
                    rightOrder = false
                    break
                }
            }

            if rightOrder, !line.isEmpty {
                let middleIndex = (line.count - 1) / 2
                if let middleValue = Int(line[middleIndex]) {
                    result.append(middleValue)
                }
            }
        }

        return String(result.reduce(0, +))
    }

    private func checkLine(_ line: inout [String], rules: [[String]]) -> Bool {
        var hasChanged = false

        for rule in rules {
            guard rule.count >= 2,
                let num1 = line.firstIndex(of: rule[0]),
                let num2 = line.firstIndex(of: rule[1])
            else {
                continue
            }

            if num1 > num2 {
                line.swapAt(num1, num2)
                hasChanged = true
                if checkLine(&line, rules: rules) {
                    hasChanged = true
                }
            }
        }

        return hasChanged
    }

    func solvePart2() -> String {
        let (rules, pages) = parseInput()
        var result: [Int] = []

        for var line in pages {
            if checkLine(&line, rules: rules) {
                let middleIndex = (line.count - 1) / 2
                if let middleValue = Int(line[middleIndex]) {
                    result.append(middleValue)
                }
            }
        }

        return String(result.reduce(0, +))
    }
}
