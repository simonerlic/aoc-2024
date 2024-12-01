import Foundation

public class Day01: Day {
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

    func createArrays() -> ([Int], [Int]) {
        let lines = input.split(separator: "\r\n")
        var firstNumbers = [Int]()
        var secondNumbers = [Int]()

        for line in lines {
            let numbers = line.split(separator: "   ").compactMap { Int($0) }

            if numbers.count == 2 {
                firstNumbers.append(numbers[0])
                secondNumbers.append(numbers[1])
            }
        }

        return (firstNumbers, secondNumbers)
    }

    func solvePart1() -> String {
        var (firstNumbers, secondNumbers) = createArrays()

        firstNumbers.sort()
        secondNumbers.sort()

        var answer = 0
        var i = 0
        while i < firstNumbers.count {
            answer += abs(firstNumbers[i] - secondNumbers[i])
            i += 1
        }

        return String(answer)
    }

    func solvePart2() -> String {
        let (firstNumbers, secondNumbers) = createArrays()

        var answer = 0
        for number in firstNumbers {
            let matchingNumbers = secondNumbers.filter { $0 == number }
            answer += number * matchingNumbers.count
        }

        return String(answer)
    }
}
