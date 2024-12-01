import Foundation

/*
 * Usage:
 * swift run AoC2024            # Runs current day
 * swift run AoC2024 5          # Runs Day 5
 * swift run AoC2024 5 --test   # Runs Day 5 test input
 */

func runDay(_ day: Int, useTest: Bool = false) {
    let dayClassName = String(format: "AoC2024.Day%02d", day)

    guard let dayClass = NSClassFromString(dayClassName) as? Day.Type else {
        print("Day \(day) not implemented yet!")
        return
    }

    let solution = useTest ? dayClass.withTestInput() : dayClass.init()
    print("Day \(day) Part 1:", solution.solvePart1())
    print("Day \(day) Part 2:", solution.solvePart2())
}

let arguments = CommandLine.arguments
let day =
    arguments.count > 1
    ? Int(arguments[1]) ?? Calendar.current.dateComponents(
        in: TimeZone(secondsFromGMT: 0)!, from: Date()
    ).day!
    : Calendar.current.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: Date()).day!
let useTest = arguments.contains("--test")

runDay(day, useTest: useTest)
