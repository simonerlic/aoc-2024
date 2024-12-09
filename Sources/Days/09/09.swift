import Foundation

public class Day09: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 9)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 9)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 9, type: .test))
    }

    private enum Block: Equatable {
        case file(id: Int)
        case empty

        var description: String {
            switch self {
            case .file(let id):
                return String(id)
            case .empty:
                return "."
            }
        }
    }

    private func parseInput(_ input: String) -> [Block] {
        var blocks: [Block] = []
        var fileId = 0
        var isFile = true

        for char in input {
            guard let length = Int(String(char)) else { continue }

            for _ in 0..<length {
                if isFile {
                    blocks.append(.file(id: fileId))
                } else {
                    blocks.append(.empty)
                }
            }

            if isFile {
                fileId += 1
            }
            isFile.toggle()
        }

        return blocks
    }

    private func compactDisk(_ blocks: [Block]) -> [Block] {
        var result = blocks
        var fileIndex = result.count - 1

        while fileIndex >= 0 {
            while fileIndex >= 0 {
                if case .file = result[fileIndex] {
                    break
                }
                fileIndex -= 1
            }

            if fileIndex < 0 { break }

            if let emptyIndex = result.firstIndex(of: .empty) {
                if emptyIndex < fileIndex {
                    result.swapAt(fileIndex, emptyIndex)
                }
            }

            fileIndex -= 1
        }

        return result
    }

    private func calculateChecksum(_ blocks: [Block]) -> Int {
        var sum = 0

        for (index, block) in blocks.enumerated() {
            if case .file(let id) = block {
                sum += index * id
            }
        }

        return sum
    }

    func solvePart1() -> String {
        let blocks = parseInput(input.trimmingCharacters(in: .whitespacesAndNewlines))
        let compactedBlocks = compactDisk(blocks)
        let checksum = calculateChecksum(compactedBlocks)
        return String(checksum)
    }

    func solvePart2() -> String {
        var blocks = parseInput(input.trimmingCharacters(in: .whitespacesAndNewlines))

        var filePositions: [Int: [Int]] = [:]
        for (index, block) in blocks.enumerated() {
            if case .file(let id) = block {
                filePositions[id, default: []].append(index)
            }
        }

        let sortedFileIds = filePositions.keys.sorted(by: >)

        for fileId in sortedFileIds {
            let fileIndices = filePositions[fileId]!
            let fileSize = fileIndices.count

            var bestMovePosition = -1
            var currentEmptyCount = 0
            var currentEmptyStart = -1

            for i in 0..<fileIndices[0] {
                if blocks[i] == .empty {
                    if currentEmptyStart == -1 {
                        currentEmptyStart = i
                    }
                    currentEmptyCount += 1

                    if currentEmptyCount >= fileSize {
                        bestMovePosition = currentEmptyStart
                        break
                    }
                } else {
                    currentEmptyCount = 0
                    currentEmptyStart = -1
                }
            }

            if bestMovePosition != -1 {
                for index in fileIndices {
                    blocks[index] = .empty
                }

                for offset in 0..<fileSize {
                    blocks[bestMovePosition + offset] = .file(id: fileId)
                }
            }
        }

        return String(calculateChecksum(blocks))
    }
}
