import Foundation

struct RGB {
    let r: Float
    let g: Float
    let b: Float
};

enum HexToRgbErrors: Error {
    case invalidHexColor(String)
}

func hexToRgb(_ hex: String) throws -> RGB {
  let regex = try NSRegularExpression(pattern: "^#?([a-f\\d]{2})([a-f\\d]{2})([a-f\\d]{2})$")
  let result = regex.matches(in: hex, options: [], range: NSRange(hex.startIndex..<hex.endIndex, in: hex))

  guard result.count > 0, result[0].numberOfRanges >= 3 else {
    print(result)
    throw HexToRgbErrors.invalidHexColor(hex)
  }

  let rangeR = Range(result[0].range(at: 1), in: hex)!
  let rangeG = Range(result[0].range(at: 2), in: hex)!
  let rangeB = Range(result[0].range(at: 3), in: hex)!

  let convertComponent = { (_ componentString: String) -> Float in
      let intValue = Int(componentString, radix: 16)
      return Float(intValue!) / 255.0
  }

  return RGB(
      r: convertComponent(hex.substring(with: rangeR)),
      g: convertComponent(hex.substring(with: rangeG)),
      b: convertComponent(hex.substring(with: rangeB))
      )
}

func rgbToHex(_ rgb: RGB) -> String {
    let r = String(format: "%02X", Int(rgb.r *  255))
    let g = String(format: "%02X", Int(rgb.g *  255))
    let b = String(format: "%02X", Int(rgb.b *  255))
    return "#\(r)\(g)\(b)"
}
