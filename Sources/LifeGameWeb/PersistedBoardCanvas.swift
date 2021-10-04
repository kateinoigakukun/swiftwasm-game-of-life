import JavaScriptKit
import LifeGame

class PersistedBoardCanvas: BasicBoardCanvas {
    let stepsCount = 9
    let liveStepsColor: [String]

    var persisted:[[Int]]

    public required init(canvas: JSObject, size: (width: Int, height: Int), liveColor: String) {
        let rgb = try! hexToRgb(liveColor)
        let rgbOffset = RGB(r: rgb.r / Float(self.stepsCount), g: rgb.g / Float(stepsCount), b: rgb.b / Float(stepsCount))

        self.liveStepsColor = (0..<stepsCount).map{ (count) in
            let steppedRGB = RGB(r: rgbOffset.r * Float(count), g: rgbOffset.g * Float(count), b: rgbOffset.b * Float(count))
            return rgbToHex(steppedRGB)
        }
        
        self.persisted = (1...width).map( { _ in 
            return (1...height).map( { _ in
                return 0
            })
        })

        super.init(canvas: canvas, size: size, liveColor: liveColor)
    }

    override public var shouldDrawCellOnNoUpdate: Bool {
        return true
    }
    
    func needsRedraw(_ cell: Cell, at point: Point) {
        if (self.persisted[point.x][point.y] > 0) {
            drawPoint(at: point, color: self.liveStepsColor[persisted[point.x][point.y]])
        } else {
            clearPoint(at: point)
        }
    }

    override public func drawCell(_ cell: Cell, at point: Point) {
        var changed = false
        if cell.live {
            if (self.persisted[point.x][point.y] != self.liveStepsColor.count - 1) {
                changed = true
                self.persisted[point.x][point.y] = self.liveStepsColor.count - 1
            }
        } else {
            if (self.persisted[point.x][point.y] > 0) {
                changed = true
                self.persisted[point.x][point.y] -= 1
            }
        }
        if changed {
            self.needsRedraw(cell, at: point)   
        }
    }
}
