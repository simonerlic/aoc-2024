import Foundation

class Day02 {
    private let input: String

    init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 1)
    }

    static func withTestInput() -> Day01 {
        return Day01(input: FileReader.readInput(for: 1, type: .test))
    }

    func solvePart1() -> String {
        let sanitizedInput = input.replacingOccurrences(of: "\r\n", with: "")
        let arr = sanitizedInput.split(separator: ",")
        var x = 0

        print(arr)

        for i in arr {
            x += Int(i)!
        }

        return String(x)
    }

    func solvePart2() -> String {
        // Your solution for part 2
        return "Not implemented yet"
    }
}
