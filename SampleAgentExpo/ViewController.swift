//
//  ViewController.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/14/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import UIKit

protocol SurveyLoadProtocol {
    func loadNext() -> (poll:Poll, isLast: Bool)
    func loadFirst() -> (poll:Poll, isLast: Bool)
    func loadLast() -> (poll:Poll, isLast: Bool)
    func loadPrev() -> (poll:Poll, isLast: Bool)
    func loadDataForSurvey() -> (poll:Poll, isLast: Bool)
    func dataIndex() -> Int
}

protocol SurveySaveProtocol {
    func saveSurvey(poll: Poll, choiceId: String)
    func submitPoll()
}

class ViewController: BaseViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startSurveyButton: UIButton!
    var surveyIndex: Int! = -1
    var pollResponse:[SurveyResponse] = []
    var percentageScore: Int!
    
    private var fontManager:FontManager!
    let transition = BubbleTransition()
    
    var resultsViewController: ResultsViewController {
        get {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            return storyboard.instantiateViewController(withIdentifier: "result") as! ResultsViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        debugPrint("Data from Application Manager: \(appDelegate.applicationManager.agentSecurityPoll.count)")
        self.fontManager = ((UIApplication.shared.delegate) as! AppDelegate).applicationManager.fontManager
        surveyIndex = -1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: Move colors to ColorManager
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.titleLabel.font = self.fontManager?.fontForName(name: "headerFont")
        self.titleLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.messageLabel.font = self.fontManager?.fontForName(name: "bodyFont")
        self.messageLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.startSurveyButton.titleLabel?.font = self.fontManager?.fontForName(name: "buttonFont")
        self.startSurveyButton.backgroundColor = UIColor(red: 43/255, green: 53/255, blue: 76/255, alpha: 1.0)
        self.startSurveyButton.layer.cornerRadius = 4.0
        self.startSurveyButton.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0),
                                             for: .normal)
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 117/255, blue: 222/255, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Survey" {
            let destinationVC = segue.destination as! UINavigationController
            destinationVC.transitioningDelegate = self
            destinationVC.modalPresentationStyle = .formSheet
            
            let rootVC = destinationVC.visibleViewController as! SurveyTableViewController
            rootVC.dataDelegate = self
            rootVC.surveyDelegate = self
            let (poll, isLast) = self.loadDataForSurvey()
            rootVC.poll = poll
            rootVC.isLastItem = isLast
        }
    }
    

    @IBAction func startSurveyButtonTouched(_ sender: UIButton) {
        
    }
    
}

extension ViewController: SurveyLoadProtocol {
    func loadNext() -> (poll:Poll, isLast: Bool) {
        var isLast: Bool = false
        self.surveyIndex = self.surveyIndex + 1
        if self.surveyIndex >= appDelegate.applicationManager.agentSecurityPoll.count - 1 {
            self.surveyIndex = appDelegate.applicationManager.agentSecurityPoll.count - 1
            isLast = true
        }
        
        return (poll:appDelegate.applicationManager.agentSecurityPoll[self.surveyIndex], isLast: isLast)
    }
    
    func loadPrev() -> (poll:Poll, isLast: Bool) {
        self.surveyIndex = self.surveyIndex - 1
        if self.surveyIndex <= 0 {
            self.surveyIndex = 0
        }
        
        return (poll:appDelegate.applicationManager.agentSecurityPoll[self.surveyIndex], isLast: false)
    }
    
    func loadFirst() -> (poll:Poll, isLast: Bool) {
        self.surveyIndex = 0
        return (poll:appDelegate.applicationManager.agentSecurityPoll[0], false)
    }
    
    func loadLast() -> (poll:Poll, isLast: Bool) {
        self.surveyIndex = appDelegate.applicationManager.agentSecurityPoll.count - 1
        return (poll:appDelegate.applicationManager.agentSecurityPoll[self.surveyIndex], isLast: true)
    }
    
    func dataIndex() -> Int {
        return ((self.appDelegate.applicationManager.agentSecurityPoll.count - 1) - self.surveyIndex)
    }
    
    func loadDataForSurvey() -> (poll: Poll, isLast: Bool) {
        var isLast: Bool = false
        
        self.surveyIndex = self.surveyIndex + 1
        if self.surveyIndex >= appDelegate.applicationManager.agentSecurityPoll.count - 1 {
            self.surveyIndex = appDelegate.applicationManager.agentSecurityPoll.count - 1
            isLast = true
        }
        return (poll: appDelegate.applicationManager.agentSecurityPoll[self.surveyIndex], isLast: isLast)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    // MARK: UIViewControllerTransitioningDelegate
//    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .present
//        transition.startingPoint = startSurveyButton.center
//        transition.bubbleColor = startSurveyButton.backgroundColor!
//        return transition
//    }
//
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .dismiss
//        transition.startingPoint = startSurveyButton.center
//        transition.bubbleColor = startSurveyButton.backgroundColor!
//        return transition
//    }
    
}

extension ViewController: SurveySaveProtocol {
    func saveSurvey(poll: Poll, choiceId: String) {
        var newRecord = true
        // check to see if the pollId already is there. If yes, update it, else append
        let surveyResponse = SurveyResponse(pollId: poll.id, choiceId: choiceId)
        for response: SurveyResponse in self.pollResponse {
            if response.poll_id == poll.id {
                response.choice_id = choiceId
                newRecord = false
                break
            }
        }
        
        if newRecord == true {
            self.pollResponse.append(surveyResponse)
        }
    }
    
    func submitPoll() {
        let finalScore = self.evaluateSurveyForResults()
        let percentage:Int = (finalScore * 10) / (appDelegate.applicationManager.agentSecurityPoll.count * 100)
        let resultStatus = self.resultStatusFrom(percentage: percentage)
        let resultController = self.resultsViewController
        resultController.percentageValue = percentage
        resultController.score = resultStatus
        
        self.surveyIndex = -1
        self.navigationController?.pushViewController(resultController, animated: true)
    }
    
    private func hasResponseForPoll(pollId: String) -> Bool {
        for response: SurveyResponse in self.pollResponse {
            if response.poll_id == pollId {
                return true
            }
        }
        return false
    }
    
    private func checkAndFillinMissingSurvey() {
        let polls = appDelegate.applicationManager.agentSecurityPoll
    
        for poll: Poll in polls! {
            if self.hasResponseForPoll(pollId: poll.id) == false {
                let surveyResponse = SurveyResponse(pollId: poll.id, choiceId: "C")
                self.pollResponse.append(surveyResponse)
            }
        }
    }
    
    private func evaluateSurveyForResults() -> Int {
        var finalScore: Int = 0
        if self.pollResponse.count < appDelegate.applicationManager.agentSecurityPoll.count {
            self.checkAndFillinMissingSurvey()
        }
        
        for response: SurveyResponse in self.pollResponse {
            if response.choice_id == "A" {
                finalScore = finalScore + 100
            } else if response.choice_id == "B" {
                finalScore = finalScore + 10
            } else {
                finalScore = finalScore + 0
            }
        }
        
        return finalScore
    }
    
    private func resultStatusFrom(percentage: Int) -> String {
        var text = "Low"
        if percentage > 3 && percentage <= 7 {
            text = "Medium"
        } else if percentage > 7 {
            text = "High"
        }
        
        return text
    }
}
