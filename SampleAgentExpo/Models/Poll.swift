//
//  Poll.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/15/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation

class Poll: NSObject {
 
    var id: String!
    var title: String!
    var details: PollDetails!
    
    
    init(id: String, title: String, details: PollDetails) {
        self.id = id
        self.title = title
        self.details = details
    }
    
}
