import Foundation

public class Day03: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 1)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 1)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 1, type: .test))
    }

    func solvePart1() -> String {
        return "Not implemented yet"
    }

    func solvePart2() -> String {
        return "Not implemented yet"
    }
}
