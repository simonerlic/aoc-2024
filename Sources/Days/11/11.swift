import Foundation

public class Day11: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 11)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 11)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 11, type: .test))
    }

    private func countFutureStones(_ stone: Int, afterIterations: Int, cache: inout [String: Int])
        -> Int
    {
        // Create cache key
        let cacheKey = "\(stone)_\(afterIterations)"

        // Check cache
        if let cached = cache[cacheKey] {
            return cached
        }

        // Base case - no more iterations
        if afterIterations == 0 {
            return 1
        }

        let digitCount = stone == 0 ? 1 : Int(log10(Double(stone))) + 1
        var result: Int

        // Apply rules
        if stone == 0 {
            // Will become 1 in next iteration
            result = countFutureStones(1, afterIterations: afterIterations - 1, cache: &cache)
        } else if digitCount % 2 == 0 {
            // Will split into two numbers
            let divisor = Int(pow(10.0, Double(digitCount / 2)))
            let leftHalf = stone / divisor
            let rightHalf = stone % divisor
            result =
                countFutureStones(leftHalf, afterIterations: afterIterations - 1, cache: &cache)
                + countFutureStones(rightHalf, afterIterations: afterIterations - 1, cache: &cache)
        } else {
            // Will multiply by 2024
            result = countFutureStones(
                stone * 2024, afterIterations: afterIterations - 1, cache: &cache)
        }

        // Cache and return result
        cache[cacheKey] = result
        return result
    }

    func solvePart1() -> String {
        let stones = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespaces)
            .map { Int($0)! }

        var cache: [String: Int] = [:]
        var totalStones = 0

        // Add progress tracking
        print("Starting calculation for \(stones.count) stones...")
        for (index, stone) in stones.enumerated() {
            print("Processing stone \(index + 1)/\(stones.count): \(stone)")
            let count = countFutureStones(stone, afterIterations: 75, cache: &cache)
            totalStones += count
            print("Stone \(stone) will produce \(count) stones after 75 iterations")
            print("Current total: \(totalStones)")
            print("Cache size: \(cache.count) entries")
            print("---")
        }

        return String(totalStones)
    }

    func solvePart2() -> String {
        let stones = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespaces)
            .map { Int($0)! }

        var cache: [String: Int] = [:]
        var totalStones = 0

        // Add progress tracking
        print("Starting calculation for \(stones.count) stones...")
        for (index, stone) in stones.enumerated() {
            print("Processing stone \(index + 1)/\(stones.count): \(stone)")
            let count = countFutureStones(stone, afterIterations: 75, cache: &cache)
            totalStones += count
            print("Stone \(stone) will produce \(count) stones after 75 iterations")
            print("Current total: \(totalStones)")
            print("Cache size: \(cache.count) entries")
            print("---")
        }

        return String(totalStones)
    }
}
