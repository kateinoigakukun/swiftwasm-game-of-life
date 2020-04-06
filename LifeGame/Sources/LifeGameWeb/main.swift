import LifeGame
import JavaScriptKit

class App: BoardUpdater {
    var cells: [[Cell]]
    let canvas: BoardCanvas

    var timer: JSValue?

    init(initial: [[Cell]], canvas: BoardCanvas) {
        self.cells = initial
        self.canvas = canvas

        forEachCell(initial) { (cell, point) in
            canvas.drawCell(cell, at: point)
        }
    }

    func update(at point: Point, cell: Cell) {
        cells[point.y][point.x] = cell
        canvas.drawCell(cell, at: point)
    }

    func iterate() {
        LifeGame.iterate(cells, updater: self)
    }

    func start() {
        guard self.timer == nil else { return }
        let fn = JSFunctionRef.from { [weak self] _ in
            self?.iterate()
            return .undefined
        }
        self.timer = JSObjectRef.global.setInterval!(fn, 50)
    }

    func stop() {
        guard let timer = self.timer else { return }
        _ = JSObjectRef.global.clearInterval!(timer)
        self.timer = nil
    }
}

let width = 50
let height = 50

func initialCells() -> [[Cell]] {
    (0..<height).map { _ in
        (0..<width).map { _ in
            Cell(live: Bool.random())
        }
    }
}

let document = JSObjectRef.global.document.object!
let canvas = document.getElementById!("app-canvas").object!
let iterateButton = document.getElementById!("app-step-button").object!
let startButton = document.getElementById!("app-start-button").object!
let stopButton = document.getElementById!("app-stop-button").object!
let resetButton = document.getElementById!("app-reset-button").object!

let initial = initialCells()
let boardView = BoardCanvas(canvas: canvas, size: (width, height))
var lifeGame = App(initial: initial, canvas: boardView)

iterateButton.onclick = .function { _ in
    lifeGame.iterate()
    return .undefined
}

startButton.onclick = .function { _ in
    lifeGame.start()
    return .undefined
}

stopButton.onclick = .function { _ in
    lifeGame.stop()
    return .undefined
}

resetButton.onclick = .function { _ in
    lifeGame = App(initial: initialCells(), canvas: boardView)
    return .undefined
}
