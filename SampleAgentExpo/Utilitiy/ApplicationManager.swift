//
//  ApplicationManager.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/20/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation

protocol AppDataProtocol {
    func loadData() -> [Poll]
}

class LocalDataManager: AppDataProtocol {

    var localDataFile: String!
    let dataManager: AgentSecurityDataManager!
    
    
    init(dataManager: AgentSecurityDataManager) {
//        super.init()
        self.dataManager = dataManager
    }
    
    func loadData() -> [Poll] {
        return self.dataManager.loadDataFromJSON()!
    }
}

class ApplicationManager {
    var agentSecurityPoll: [Poll]!
    var fontManager: FontManager!
    
    static let sharedInstance : ApplicationManager = {
        let instance = ApplicationManager()
        instance.fontManager = FontManager.sharedInstance
        return instance
    }()
    
    func loadPollInformation() {
        let agentSecurityDataManager = AgentSecurityDataManager()
        let dataManager: LocalDataManager = LocalDataManager(dataManager: agentSecurityDataManager)
        self.agentSecurityPoll = dataManager.loadData()
    }
    
}
