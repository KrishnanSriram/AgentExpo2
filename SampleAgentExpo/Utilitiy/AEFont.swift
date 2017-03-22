//
//  AEFont.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/20/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation
import UIKit

class AEFont {
    var fontName: String!
    var fontSize: CGFloat!
    var fontStyle: String!
    
    init(name: String, size: CGFloat, style: String) {
        self.fontName = name
        self.fontSize = size
        self.fontStyle = style
    }
}
