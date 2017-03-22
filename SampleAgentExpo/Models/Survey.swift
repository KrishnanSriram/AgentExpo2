//
//  Survey.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/15/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation

class Survey: NSObject {
    var polls: [Poll]!
    
    init(withPolls polls: [Poll]) {
        self.polls = polls
    }
    
}
