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

    func solvePart1() -> String {
        return "Not implemented"
    }

    func solvePart2() -> String {
        return "Not implemented"
    }
}
