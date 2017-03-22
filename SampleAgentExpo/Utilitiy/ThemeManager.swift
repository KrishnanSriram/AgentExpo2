//
//  ThemeManager.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/20/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation

class ThemeManager: DataManager {
    static let sharedInstance : ThemeManager = {
        let instance = ThemeManager()
        return instance
    }()
}
