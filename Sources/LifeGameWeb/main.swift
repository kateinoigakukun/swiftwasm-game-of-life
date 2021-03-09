import LifeGame
import JavaScriptKit

class App: BoardUpdater {
    var cells: [[Cell]]
    let canvas: BoardCanvas
    let rule: Rule

    var timer: JSValue?
    lazy var tickFn = JSClosure { [weak self] _ in
        self?.iterate()
    }

    init(initial: [[Cell]], canvas: BoardCanvas, rule: Rule) {
        self.cells = initial
        self.canvas = canvas
        self.rule = rule

        forEachCell(initial) { (cell, point) in
            canvas.drawCell(cell, at: point)
        }
    }

    func update(at point: Point, cell: Cell) {
        cells[point.y][point.x] = cell
        canvas.drawCell(cell, at: point)
    }

    func iterate() {
        LifeGame.iterate(cells, updater: self, rule: rule)
    }

    func start() {
        guard self.timer == nil else { return }
        self.timer = JSObject.global.setInterval!(tickFn, 50)
    }

    func stop() {
        guard let timer = self.timer else { return }
        _ = JSObject.global.clearInterval!(timer)
        self.timer = nil
    }
}

func initialCells(width: Int, height: Int) -> [[Cell]] {
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

var ruleSelect = document.getElementById("app-rule")
var ruleCustomBirth = document.getElementById("app-rule-custom-birth")
var ruleCustomSurvive = document.getElementById("app-rule-custom-survive")
var rule = try Rule(ruleString: ruleSelect.value.string!)

var controlsContainer = document.getElementById("app-controls-container")

let width = Int(document.body.clientWidth.number!) / (BoardCanvas.cellSize + BoardCanvas.boarderWidth)
let height = Int(document.body.clientHeight.number! - controlsContainer.clientHeight.number!) / (BoardCanvas.cellSize + BoardCanvas.boarderWidth)
let boardView = BoardCanvas(canvas: canvas, size: (width, height))

var lifeGame = App(initial: initialCells(width: width, height: height), canvas: boardView, rule: rule)

let iterateFn = JSClosure { _ in
    lifeGame.iterate()
    return nil
}

let startFn = JSClosure { _ in
    lifeGame.start()
    return nil
}

let stopFn = JSClosure { _ in
    lifeGame.stop()
    return nil
}

let resetFn = JSClosure { _ in
    lifeGame = App(initial: initialCells(width: width, height: height), canvas: boardView, rule: rule)
    return nil
}

let updateRuleFn = JSClosure { _ in
    switch ruleSelect.value.string! {
    case "custom":
        ruleCustomBirth.disabled = .boolean(false)
        ruleCustomSurvive.disabled = .boolean(false)

        rule = try! Rule(ruleString: "B\(ruleCustomBirth.value.string!)/S\(ruleCustomSurvive.value.string!)")
    default:
        ruleCustomBirth.disabled = .boolean(true)
        ruleCustomSurvive.disabled = .boolean(true)

        rule = try! Rule(ruleString: ruleSelect.value.string!)
    }
    lifeGame = App(initial: initialCells(width: width, height: height), canvas: boardView, rule: rule)
    return nil
}

iterateButton.onclick = .function(iterateFn)
startButton.onclick = .function(startFn)
stopButton.onclick = .function(stopFn)
resetButton.onclick = .function(resetFn)

ruleSelect.onchange = .function(updateRuleFn)
ruleCustomBirth.onchange = .function(updateRuleFn)
ruleCustomSurvive.onchange = .function(updateRuleFn)
