//
//  ResultsViewController.swift
//  AgentSecurityCheck
//
//  Created by Krishnan Sriram Rama on 2/3/17.
//  Copyright © 2017 Krishnan Sriram Rama. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var topTachometer: SFGaugeView!
    var percentageValue: Int!
    var score: String!
    var pollResponse: [SurveyResponse]!
    var actionToEnable: UIAlertAction?
    @IBOutlet weak var lowLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var highLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var highLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerResultsLabel: UILabel!
    @IBOutlet weak var bodyResultsLabel: UILabel!
    @IBOutlet weak var footerResultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Results"
        
        self.topTachometer.backgroundColor = UIColor.white
        self.topTachometer.bgColor = UIColor(red: CGFloat(249 / 255.0), green: CGFloat(203 / 255.0),
                                             blue: CGFloat(0 / 255.0), alpha: CGFloat(1))
        self.topTachometer.needleColor = UIColor(red: CGFloat(247 / 255.0), green: CGFloat(164 / 255.0),
                                                 blue: CGFloat(2 / 255.0), alpha: CGFloat(1))
        self.topTachometer.isHideLevel = true

        
        self.topTachometer.isAutoAdjustImageColors = true
        self.topTachometer.currentLevel = percentageValue
        self.navigationController?.isNavigationBarHidden = false

        let rightBarButton = UIBarButtonItem(title: "Reset",
                                             style: .plain,
                                             target: self,
                                             action: #selector(resetButtonTapped(sender:)))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.hidesBackButton = true
        self.lowLabelTrailingConstraint.constant = -70
        self.lowLabelBottomConstraint.constant = -30
        self.highLabelTrailingConstraint.constant = -60
        self.highLabelBottomConstraint.constant = -30
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateLabelsByStatus(status: self.score)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func subscribeButtonTapped(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Email ID for subscription",
                                                message: "Please enter your email ID", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Notify", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let contactsTable = ContactsTable()
            contactsTable.insertEMailItemWithCompletionHandler(email: firstTextField.text!,
                                                               score: self.score,
                                                               status: "New",
                                                               detailedScore: self.JSONResponseFromSurveyResults(contact: firstTextField.text!),
                                                               completionHandler: { (error) in
                if error != nil {
                    self.persistResultsLocally(contact: firstTextField.text!)
                } else {
                    debugPrint("Data is now persisted")
                }
            })
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your Email ID"
            textField.keyboardType = .emailAddress
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.actionToEnable = saveAction
        saveAction.isEnabled = false
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    func validateTextFieldForEMail(text: String?) -> Bool {
        var retFlag = false
        if let _ = text {
          retFlag = self.isValidEmail(emailStr: text!)
        }
        
        return retFlag
    }
    
    func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled  = self.validateTextFieldForEMail(text: sender.text)
    }
    
    func resetButtonTapped(sender: UIBarButtonItem) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ResetQuizNotification")))
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func updateLabelsByStatus(status: String) {
        if status == "Low" {
            self.headerResultsLabel.text = "Basic"
            self.bodyResultsLabel.text = "Your agency may be at risk from control gaps in your security practices."
            self.footerResultsLabel.text = "For more information view sections within our Agency Security Guide."
        } else if status == "Medium" {
            self.headerResultsLabel.text = "Moderate"
            self.bodyResultsLabel.text = "It looks like your agency security posture is built on a modest foundation but you could do with improvements in some areas."
            self.footerResultsLabel.text = "Take a look at the relevant sections of our Agency Security Guide to see where you can make adjustments."
        } else {
            self.headerResultsLabel.text = "Advanced"
            self.bodyResultsLabel.text = "Keep up the great work and continue to remain vigilant about security risks as your agency grows and evolves."
            self.footerResultsLabel.text = "Try reading the relevant areas of our Agency Security Guide to find steps you can take to improve your agency security posture."
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func newFileName() -> String {
        let uuid = NSUUID().uuidString
        return uuid + ".json"
    }
    
    private func persistResultsLocally(contact: String) {
        let dataAsString: String = self.JSONResponseFromSurveyResults(contact: contact)
        let filename = getDocumentsDirectory().appendingPathComponent(self.newFileName())
        debugPrint("File name: " + filename.absoluteString)
        do {
            try dataAsString.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }

    }
    
    private func JSONResponseFromSurveyResults(contact: String) -> String {
        var jsonString = "{\"contact\":\"" + contact + "\",\"results\":["
        
        for response in self.pollResponse {
            jsonString = jsonString + response.toJSON() + ","
        }
        jsonString.remove(at: jsonString.characters.index(before: jsonString.endIndex))
        
        jsonString = jsonString + "]}"
        

        debugPrint("JSON String: \(jsonString)")
        print("JSON String: \(jsonString)")
        return jsonString
    }

}
