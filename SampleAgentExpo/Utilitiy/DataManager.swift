//
//  DataManager.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/20/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import Foundation

class DataManager {
    func JSONToDictionary(data: NSData) -> NSDictionary? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data,
                                                    options: .mutableContainers) as? NSDictionary
        } catch let jsonError {
            print(jsonError)
        }
        return nil
    }
}
