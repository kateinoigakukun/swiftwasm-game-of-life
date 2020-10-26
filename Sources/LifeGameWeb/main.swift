import LifeGame
import JavaScriptKit

class App: BoardUpdater {
    var cells: [[Cell]]
    let canvas: BoardCanvas

    var timer: JSValue?
    lazy var tickFn = JSClosure { [weak self] _ in
        self?.iterate()
    }

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
        self.timer = JSObject.global.setInterval!(tickFn, 50)
    }

    func stop() {
        guard let timer = self.timer else { return }
        _ = JSObject.global.clearInterval!(timer)
        tickFn.release()
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

let document = JSObject.global.document
let canvas = document.getElementById("app-canvas").object!
var iterateButton = document.getElementById("app-step-button")
var startButton = document.getElementById("app-start-button")
var stopButton = document.getElementById("app-stop-button")
var resetButton = document.getElementById("app-reset-button")

let initial = initialCells()
let boardView = BoardCanvas(canvas: canvas, size: (width, height))
var lifeGame = App(initial: initial, canvas: boardView)

let iterateFn = JSClosure { _ in
    lifeGame.iterate()
}

let startFn = JSClosure { _ in
    lifeGame.start()
}

let stopFn = JSClosure { _ in
    lifeGame.stop()
}

let resetFn = JSClosure { _ in
    lifeGame = App(initial: initialCells(), canvas: boardView)
}

iterateButton.onclick = .function(iterateFn)
startButton.onclick = .function(startFn)
stopButton.onclick = .function(stopFn)
resetButton.onclick = .function(resetFn)
