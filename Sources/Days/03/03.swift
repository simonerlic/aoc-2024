import Foundation

public class Day03: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 3)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 3)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 3, type: .test))
    }

    func solvePart1() -> String {
        return calculateSum(using: "mul\\((\\d+),(\\d+)\\)")
    }

    func solvePart2() -> String {
        return calculateSum(using: "mul\\((\\d+),(\\d+)\\)|do\\(\\)|don't\\(\\)")
    }

    private func calculateSum(using pattern: String) -> String {
        let regex = try! NSRegularExpression(pattern: pattern)
        let nsString = input as NSString
        let matches = regex.matches(in: input, range: NSRange(location: 0, length: nsString.length))

        var sum = 0
        var isEnabled = true

        for match in matches {
            let matchString = nsString.substring(with: match.range)

            if matchString == "do()" {
                isEnabled = true
            } else if matchString == "don't()" {
                isEnabled = false
            } else if match.numberOfRanges == 3 {
                let xRange = match.range(at: 1)
                let yRange = match.range(at: 2)

                if let x = Int(nsString.substring(with: xRange)),
                    let y = Int(nsString.substring(with: yRange)),
                    isEnabled
                {
                    sum += x * y
                }
            }
        }

        return String(sum)
    }
}
