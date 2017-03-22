//
//  PollChoiceDetails.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/15/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation
class PollChoiceDetails: NSObject {
    var choiceId: String!
    var choice: String!
    var weight: String!
    
    init(id: String, choice: String) {
        self.choiceId = id
        self.choice = choice
    }
    
    init(id: String, choice: String, weight: String) {
        self.choiceId = id
        self.choice = choice
        self.weight = weight
    }
}
