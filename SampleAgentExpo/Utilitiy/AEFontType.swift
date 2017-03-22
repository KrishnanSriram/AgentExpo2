//
//  AEFontType.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/20/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation
import UIKit

class AEFontType {
    var fontType: String!
    var font: AEFont!
    
    init(fontType: String, font: AEFont) {
        self.fontType = fontType
        self.font = font
    }
    
    func fontFromType() -> UIFont {
        var fontName = self.font.fontName
        if self.font.fontStyle != nil && self.font.fontStyle.characters.count > 0 {
            fontName = fontName! + "-" + self.font.fontStyle
        }
        return UIFont(name: fontName!, size: self.font.fontSize)!
    }
}
