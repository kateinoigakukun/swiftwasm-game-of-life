import XCTest
@testable import LifeGame

func makeCells(from text: String) -> [[Cell]] {
    let lines = text.split(whereSeparator: \.isNewline)
    var cells: [[Cell]] = []
    cells.reserveCapacity(lines.count)
    for line in text.split(whereSeparator: \.isNewline) {
        cells.append(line.map {
            Cell(live: $0 == "o")
        })
    }
    return cells
}

func toString(from cells: [[Cell]]) -> String {
    cells.map {
        $0.map { $0.live ? "o" : "x" }.joined()
    }.joined(separator: "\n")
}

class VirtualBoard: BoardUpdater, Equatable {
    var cells: [[Cell]] = []
    init(from text: String) {
        self.cells = makeCells(from: text)
    }
    func update(at point: Point, cell: Cell) {
        cells[point.y][point.x] = cell
    }

    static func == (lhs: VirtualBoard, rhs: VirtualBoard) -> Bool {
        lhs.cells == rhs.cells
    }
}

final class LifeGameTests: XCTestCase {

    func testIterate() {
        typealias TestCase = (from: String, next: String, line: UInt)
        let testCases: [TestCase] = [
            (from: "oox\noxx\nxxx", next: "oox\noox\nxxx", line: #line),
            (from: "xxxx\nxoox\nxoox\nxxxx", next: "xxxx\nxoox\nxoox\nxxxx", line: #line),
            (from: "xxx\nxox\nxxx", next: "xxx\nxxx\nxxx", line: #line),
            (from: "xox\nooo\nxox", next: "ooo\noxo\nooo", line: #line),
        ]
        for testCase in testCases {
            let board = VirtualBoard(from: testCase.from)
            iterate(board.cells, updater: board)
            XCTAssertEqual(toString(from: board.cells),
                           testCase.next, line: testCase.line)
        }
    }
}
