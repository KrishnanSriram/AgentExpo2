//
//  SurveyTViewController.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/15/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import UIKit

class SurveyTableViewController: UITableViewController {
    
    var poll: Poll!
    var isLastItem: Bool!
    var dataDelegate: SurveyLoadProtocol!
    var surveyDelegate: SurveySaveProtocol!
    
    private lazy var nextBarButtonItem: UIBarButtonItem = UIBarButtonItem(title:"Next", style:.plain,
                                                                          target: self,
                                                                          action: #selector(SurveyTableViewController.nextButtonTapped(sender:)))
    private lazy var prevBarButtonItem: UIBarButtonItem = UIBarButtonItem(title:"Prev", style:.plain,
                                                                          target: self, action: #selector(prevButtonTapped(sender:)))
    private lazy var submitBarButtonItem: UIBarButtonItem = UIBarButtonItem(title:"Next", style:.plain, target: self,
                                                                        action: #selector(nextButtonTapped(sender:)))
    private var fontManager = ((UIApplication.shared.delegate) as! AppDelegate).applicationManager.fontManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 500, height: 550)
        self.title = self.poll.title
        self.isLastItem = false
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "ChoiceCell")
        self.navigationItem.leftBarButtonItem = prevBarButtonItem
        self.updateBarButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle  = .blackOpaque
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.animateTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
//        headerView.contentView.backgroundColor = UIColor(red: 46/255, green: 190/255, blue: 206/255, alpha: 1.0)
        headerView.textLabel?.font = self.fontManager?.fontForName(name: "tableSectionHeaderFont")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.poll.details.title
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
//        footerView.contentView.backgroundColor = UIColor(red: 46/255, green: 190/255, blue: 206/255, alpha: 1.0)
        footerView.textLabel?.font = self.fontManager?.fontForName(name: "tableSectionFooterFont")
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "\(self.dataDelegate.dataIndex()) more questions to go"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.poll.details.choices.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 43/255, green: 53/255, blue: 76/255, alpha: 1.0)
        cell.textLabel?.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiceCell", for: indexPath)
        
        cell.textLabel?.text = self.poll.details.choices[indexPath.row].choice
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = self.fontManager?.fontForName(name: "tableCellTextFont")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1.0)
        let choiceDetails = self.poll.details.choices[indexPath.row]
        self.surveyDelegate.saveSurvey(poll: self.poll, choiceId: choiceDetails.choiceId)
    }
    
    //MARK: - Action methods
    @IBAction func nextButtonTapped(sender: UIBarButtonItem) {
        if sender.title == "Next" {
            debugPrint("Next button tapped")
            let (poll, lastItem) = self.dataDelegate.loadNext()
            self.poll = poll
            self.isLastItem = lastItem
            self.tableView.reloadData()
            self.title = self.poll.title
            self.updateBarButtons()
            animateTable()
        } else {
            self.submitButtonTapped(sender: sender)
        }
        
    }
    
    @IBAction func prevButtonTapped(sender: UIBarButtonItem) {
        let (poll, lastItem) = self.dataDelegate.loadPrev()
        self.poll = poll
        self.isLastItem = lastItem
        self.tableView.reloadData()
        self.title = self.poll.title
        self.updateBarButtons()
        animateTable()
    }
    
    @IBAction func submitButtonTapped(sender: UIBarButtonItem) {
        debugPrint("Submit button tapped")
        self.surveyDelegate.submitPoll()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Utility methods
    func updateBarButtons() {
        if self.isLastItem == true {
            self.navigationItem.rightBarButtonItem = submitBarButtonItem
            self.navigationItem.rightBarButtonItem?.title = "Submit"
        } else {
            self.navigationItem.rightBarButtonItem = nextBarButtonItem
            self.navigationItem.rightBarButtonItem?.title = "Next"
        }
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                           options: .transitionCurlUp, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
}
