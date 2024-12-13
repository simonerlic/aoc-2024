import Foundation

public class Day13: Day {
    private let input: String

    required init() {
        self.input = FileReader.readInput(for: 13)
    }

    required init(input: String? = nil) {
        self.input = input ?? FileReader.readInput(for: 13)
    }

    static func withTestInput() -> Self {
        return self.init(input: FileReader.readInput(for: 13, type: .test))
    }

    func solvePart1() -> String {
        let lines = input.components(separatedBy: .newlines)
        var machines: [(ax: Int, ay: Int, bx: Int, by: Int, px: Int, py: Int)] = []
        var currentLines: [String] = []

        for line in lines {
            if line.isEmpty {
                if currentLines.count == 3 {
                    if let machine = parseMachine(currentLines) {
                        machines.append(machine)
                    }
                    currentLines = []
                }
                continue
            }
            currentLines.append(line)
        }

        if currentLines.count == 3 {
            if let machine = parseMachine(currentLines) {
                machines.append(machine)
            }
        }

        var totalTokens = 0

        for machine in machines {
            var minTokens: Int?

            for a in 0...100 {
                for b in 0...100 {
                    let x = a * machine.ax + b * machine.bx
                    let y = a * machine.ay + b * machine.by

                    if x == machine.px && y == machine.py {
                        let tokens = (a * 3) + b
                        if minTokens == nil || tokens < minTokens! {
                            minTokens = tokens
                        }
                    }
                }
            }

            if let tokens = minTokens {
                totalTokens += tokens
            }
        }

        return String(totalTokens)
    }

    private func parseMachine(_ lines: [String]) -> (
        ax: Int, ay: Int, bx: Int, by: Int, px: Int, py: Int
    )? {
        guard lines.count == 3 else { return nil }

        // button A
        guard let aMatch = lines[0].firstMatch(of: /X\+(\d+), Y\+(\d+)/),
            let ax = Int(aMatch.1),
            let ay = Int(aMatch.2)
        else { return nil }

        // button B
        guard let bMatch = lines[1].firstMatch(of: /X\+(\d+), Y\+(\d+)/),
            let bx = Int(bMatch.1),
            let by = Int(bMatch.2)
        else { return nil }

        // prize
        guard let pMatch = lines[2].firstMatch(of: /X=(\d+), Y=(\d+)/),
            let px = Int(pMatch.1),
            let py = Int(pMatch.2)
        else { return nil }

        return (ax, ay, bx, by, px, py)
    }

    func solvePart2() -> String {
        let lines = input.components(separatedBy: .newlines)
        var machines: [(ax: Int, ay: Int, bx: Int, by: Int, px: Int, py: Int)] = []
        var currentLines: [String] = []

        for line in lines {
            if line.isEmpty {
                if currentLines.count == 3 {
                    if let machine = parseMachine(currentLines) {
                        machines.append(machine)
                    }
                    currentLines = []
                }
                continue
            }
            currentLines.append(line)
        }

        if currentLines.count == 3 {
            if let machine = parseMachine(currentLines) {
                machines.append(machine)
            }
        }

        var totalTokens = 0

        for machine in machines {
            let px = machine.px + 10_000_000_000_000
            let py = machine.py + 10_000_000_000_000

            // ok, so we want to solve:
            // ax * A + bx * B = px
            // ay * A + by * B = py

            // substitute B from first equation into second:
            // B = (px - ax * A) / bx
            // ay * A + by * ((px - ax * A) / bx) = py
            // simplify:
            // (ay * bx - by * ax) * A = py * bx - by * px

            let coefA = machine.ay * machine.bx - machine.by * machine.ax
            if coefA == 0 { continue }

            let rsX = px
            let rsY = py

            let numA = Double(rsY * machine.bx - machine.by * rsX)
            let a = numA / Double(coefA)

            if a.truncatingRemainder(dividingBy: 1) != 0 { continue }

            let A = Int(a)
            if A < 0 { continue }

            let numB = rsX - machine.ax * A
            if numB % machine.bx != 0 { continue }

            let B = numB / machine.bx
            if B < 0 { continue }

            let tokens = A * 3 + B
            totalTokens += tokens
        }

        return String(totalTokens)
    }
}
