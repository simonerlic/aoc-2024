import Foundation

class Day02 {
    private let input: String

    init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 1)
    }

    static func withTestInput() -> Day02 {
        return Day02(input: FileReader.readInput(for: 1, type: .test))
    }

    func solvePart1() -> String {
        return "Not implemented yet"
    }

    func solvePart2() -> String {
        return "Not implemented yet"
    }
}
