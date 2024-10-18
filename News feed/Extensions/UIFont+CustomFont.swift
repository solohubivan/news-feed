//
//  UIFont+CustomFont.swift
//  News feed
//
//  Created by Ivan Solohub on 16.10.2024.
//

import UIKit

extension UIFont {
    static func customFont(name: String, size: CGFloat, textStyle: UIFont.TextStyle) -> UIFont {
        let customFont = UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont)
    }
}
