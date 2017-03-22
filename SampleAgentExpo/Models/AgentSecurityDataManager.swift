//
//  AgentSecurityDataManager.swift
//  AgentSecurityCheck
//
//  Created by Krishnan Sriram Rama on 2/13/17.
//  Copyright © 2017 Krishnan Sriram Rama. All rights reserved.
//

import Foundation
class AgentSecurityDataManager: DataManager {
//    var agentSecurityResponse: AgentSecurityResponse!
    
    override init() {
//        self.agentSecurityResponse = AgentSecurityResponse()
    }
    
    func loadDataFromJSON() -> [Poll]? {
        let file = "survey"
        let path = Bundle.main.path(forResource: file, ofType: "json")
        let pathURL = NSURL(fileURLWithPath: path!)
        var polls: [Poll]! = []
        
        if let jsonData = NSData(contentsOf: pathURL as URL) {
            if let dataDictionary = self.JSONToDictionary(data: jsonData) {
                if let pollsCollection: NSArray = dataDictionary.object(forKey: "polls") as? NSArray {
                    for index in 0..<pollsCollection.count {
                        debugPrint("polls: \(index)")
                        if let pollItem = self.extractPollInformation(poll: pollsCollection[index] as? NSDictionary) {
                            polls.append(pollItem)
                        }
                    }
                }
            }
        }
        return polls
    }
    
    
    
    private func extractPollInformation(poll: NSDictionary?) -> Poll? {
        if let item = poll {
            let title = item.object(forKey: "title") as! String
            let id = item.object(forKey: "id") as! String
            // extract poll details
            if let pollDetails = self.extractPollDetails(pollDetails: item.object(forKey: "details") as? NSDictionary) {
                return Poll(id: id, title: title, details: pollDetails)
            }
        }
        
        return nil
    }
    
    private func extractPollDetails(pollDetails: NSDictionary?) -> PollDetails? {
        var checkItemDetails:[PollChoiceDetails]! = []
        if let details = pollDetails {
            let question = details.object(forKey: "question") as! String
            let title = details.object(forKey: "title") as! String
            if let choices: NSArray = details.object(forKey: "choices") as? NSArray {
                for index in 0..<choices.count {
                    debugPrint("securityCheckItemDetails: \(index)")
                    if let choiceInfo = extractChoiceInfo(choice: choices[index] as? NSDictionary) {
                        checkItemDetails.append(choiceInfo)
                    }
                }
            }
            return PollDetails(title: title, question: question, choices: checkItemDetails)
        }
        
        return nil
    }
    
    private func extractChoiceInfo(choice: NSDictionary?) -> PollChoiceDetails? {
        if let choiceItem = choice {
            let choice = choiceItem.object(forKey: "choice") as! String
            let choice_id = choiceItem.object(forKey: "id") as! String
            let weight = choiceItem.object(forKey: "weight") as! String
            
            return PollChoiceDetails(id: choice_id, choice: choice, weight: weight)
        }
        
        return nil
    }
    
    
    
}
