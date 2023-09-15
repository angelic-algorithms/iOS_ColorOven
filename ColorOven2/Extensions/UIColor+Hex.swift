////
////  UIColor+Hex.swift
////  ColorOven2
////
////  Created by Christopher Williams on 9/6/23.
////
//
import UIKit

extension UIColor {
    convenience init?(fromRGBString rgbString: String) {
        // Use regex to extract the color components
        let pattern = "r: (\\d+), g: (\\d+), b: (\\d+)"
        let regex = try? NSRegularExpression(pattern: pattern)
        let nsString = rgbString as NSString
        if let match = regex?.firstMatch(in: rgbString, options: [], range: NSRange(location: 0, length: nsString.length)),
            let rComponent = Range(match.range(at: 1), in: rgbString),
            let gComponent = Range(match.range(at: 2), in: rgbString),
            let bComponent = Range(match.range(at: 3), in: rgbString) {
            let r = CGFloat(Int(String(rgbString[rComponent])) ?? 0) / 255.0
            let g = CGFloat(Int(String(rgbString[gComponent])) ?? 0) / 255.0
            let b = CGFloat(Int(String(rgbString[bComponent])) ?? 0) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        } else {
            print("Failed to parse color from string: \(rgbString)")
            return nil
        }
    }

    var isDarkColor: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let brightness = (red * 299 + green * 587 + blue * 114) / 1000
        
        return brightness < 0.5
    }
}
