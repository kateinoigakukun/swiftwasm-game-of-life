import JavaScriptKit
import LifeGame

protocol BoardCanvas {
    init(canvas: JSObject, size: (width: Int, height: Int), liveColor: String)
    var shouldDrawCellOnNoUpdate: Bool { get }
    func drawCell(_ cell: Cell, at point: Point)
}
