//
//  UIColor+Interpolation.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/27.
//

import UIKit

extension UIColor {

    func interpolate(with other: UIColor, percent: CGFloat) -> UIColor? {
        return UIColor.interpolate(betweenColor: self, and: other, percent: percent)
    }

    static func interpolate(betweenColor colorA: UIColor,
                            and colorB: UIColor,
                            percent: CGFloat) -> UIColor? {
        var redA: CGFloat = 0.0
        var greenA: CGFloat = 0.0
        var blueA: CGFloat = 0.0
        var alphaA: CGFloat = 0.0
        guard colorA.getRed(&redA, green: &greenA, blue: &blueA, alpha: &alphaA) else {
            return nil
        }

        var redB: CGFloat = 0.0
        var greenB: CGFloat = 0.0
        var blueB: CGFloat = 0.0
        var alphaB: CGFloat = 0.0
        guard colorB.getRed(&redB, green: &greenB, blue: &blueB, alpha: &alphaB) else {
            return nil
        }

        let iRed = CGFloat(redA + percent * (redB - redA))
        let iBlue = CGFloat(blueA + percent * (blueB - blueA))
        let iGreen = CGFloat(greenA + percent * (greenB - greenA))
        let iAlpha = CGFloat(alphaA + percent * (alphaB - alphaA))

        return UIColor(red: iRed, green: iGreen, blue: iBlue, alpha: iAlpha)
    }
}
