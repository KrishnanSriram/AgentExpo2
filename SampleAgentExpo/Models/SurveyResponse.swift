//
//  AgentSecurityResponse.swift
//  AgentSecurityCheck
//
//  Created by Sriram, Krishnan on 2/14/17.
//  Copyright © 2017 Krishnan Sriram Rama. All rights reserved.
//

import Foundation

class SurveyResponse: NSObject {
    var poll_id: String!
    var choice_id: String!
    
    init(pollId:String, choiceId:String) {
        self.poll_id = pollId
        self.choice_id = choiceId
    }

}
