import Foundation

struct FileReader {
    enum InputType {
        case input
        case test

        var filename: String {
            switch self {
            case .input: return "input.txt"
            case .test: return "test.txt"
            }
        }
    }

    static func readInput(for day: Int, type: InputType = .input) -> String {
        let dayString = String(format: "%02d", day)
        let fileURL = URL(fileURLWithPath: "Sources/Days/\(dayString)/\(type.filename)")

        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print("Error reading \(type.filename) for day \(day): \(error)")
            return ""
        }
    }
}
