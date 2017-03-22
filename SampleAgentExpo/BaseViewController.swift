//
//  BaseViewController.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/20/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let appDelegate: AppDelegate  = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
}
