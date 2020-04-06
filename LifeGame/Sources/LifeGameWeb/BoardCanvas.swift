import JavaScriptKit
import LifeGame

class BoardCanvas {

    let context: JSObjectRef

    let cellSize = 6
    let boarderWidth = 1

    let liveColor = "#29fd2f"

    init(canvas: JSObjectRef, size: (width: Int, height: Int)) {
        context = canvas.getContext!("2d").object!
        canvas.width = .number(Int32(width * (cellSize + boarderWidth)))
        canvas.height = .number(Int32(height * (cellSize + boarderWidth)))
    }

    fileprivate func getCellRect(at point: Point) -> (x: Int, y: Int, width: Int, height: Int) {
        (
            point.x * (cellSize + 1),
            point.y * (cellSize + 1),
            cellSize, cellSize
        )
    }

    fileprivate func drawPoint(at point: Point) {
        context.fillStyle = .string(liveColor)
        let rect = getCellRect(at: point)
        _ = context.fillRect!(rect.x, rect.y, rect.width, rect.height)
    }

    fileprivate func clearPoint(at point: Point) {
        let rect = getCellRect(at: point)
        _ = context.clearRect!(rect.x, rect.y, rect.width, rect.height)
    }

    func drawCell(_ cell: Cell, at point: Point) {
        if cell.live {
            drawPoint(at: point)
        } else {
            clearPoint(at: point)
        }
    }
}
