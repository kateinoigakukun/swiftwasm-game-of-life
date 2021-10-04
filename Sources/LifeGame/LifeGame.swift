import Foundation

public struct Cell: Equatable {
    public let live: Bool
    public init(live: Bool) {
        self.live = live
    }
}

public typealias Point = (x: Int, y: Int)

public protocol BoardUpdater {
    func update(at point: Point, cell: Cell)
    func noUpdate(at point: Point, cell: Cell)
}

public struct Rule {
    public let birth:[Int]
    public let survive:[Int]

    public init(birth: [Int], survive: [Int]) {
        self.birth = birth
        self.survive = survive
    }

    public init(ruleString: String) throws {
        let result = try parseRule(ruleString)
        self.init(birth: result.0, survive: result.1)
    }
}

public func iterate<U: BoardUpdater>(_ cells: [[Cell]], updater: U, rule: Rule) {
    let height = cells.count
    let width = cells[0].count

    let birthFlags = (0...8).map({ value in
        return rule.birth.contains(value)
    })
    let surviveFlags = (0...8).map({ value in
        return rule.survive.contains(value)
    })
    
    forEachCell(cells) { cell, point in
        var liveCount = 0
        for dy in [-1, 0, 1] {
            for dx in [-1, 0, 1] {
                if dy == 0 && dx == 0 { continue }
                guard 0..<height ~= (point.y + dy),
                      0..<width ~= (point.x + dx) else {
                    continue
                }

                liveCount += cells[point.y + dy][ point.x + dx].live ? 1 : 0
            }
        }

        if !cell.live {
            if (birthFlags[liveCount]) {
                updater.update(at: point, cell: Cell(live: true))
            } else {
                updater.noUpdate(at: point, cell: cell)
            }
        } else {
            if (surviveFlags[liveCount]) {
                updater.noUpdate(at: point, cell: cell)
            } else {
                updater.update(at: point, cell:  Cell(live: false))
            }
        }
    }
}

public func forEachCell(_ cells: [[Cell]], _ f: (Cell, Point) -> Void) {
    for (y, rows) in cells.enumerated() {
        for (x, cell) in rows.enumerated() {
            f(cell, (x, y))
        }
    }
}

public enum LifeGameErrors: Error {
    case unableToParseRuleString(String)
}

public func parseRule(_ string: String) throws -> ([Int], [Int]) {
    let regex = try NSRegularExpression(pattern: "^[Bb]([0-8]*)\\/[Ss]([0-8]*)$")

    guard let match = regex.firstMatch(in: string,
                                       options: [],
                                       range: NSRange(location: 0, length: string.utf8.count)),
          let birthRange = Range(match.range(at: 1), in: string),
          let surviveRange = Range(match.range(at: 2), in: string)
          else {
        throw LifeGameErrors.unableToParseRuleString(string)
    }

    let birthValuesString = string[birthRange]
    let surviveValuesString = string[surviveRange]

    return (birthValuesString.compactMap{ $0.wholeNumberValue },
            surviveValuesString.compactMap{ $0.wholeNumberValue })
}
