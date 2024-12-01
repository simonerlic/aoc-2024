import Foundation

/*
 * Usage:
 * swift run AoC2024            # Runs current day
 * swift run AoC2024 5          # Runs Day 5
 * swift run AoC2024 5 --test   # Runs Day 5 test input
 */

func runDay(_ day: Int, useTest: Bool = false) {
    switch day {
    case 1:
        let solution = useTest ? Day01.withTestInput() : Day01()
        print("Day 1 Part 1:", solution.solvePart1())
        print("Day 1 Part 2:", solution.solvePart2())
    default:
        print("Day \(day) not implemented yet!")
    }
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
