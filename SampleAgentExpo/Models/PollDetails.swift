//
//  PollDetails.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/16/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation

class PollDetails: NSObject {
    var title: String!
    var question: String!
    var choices: [PollChoiceDetails]!
    
    init(title: String, question: String, choices: [PollChoiceDetails]) {
        self.title = title
        self.question = question
        self.choices = choices
    }
    
}
