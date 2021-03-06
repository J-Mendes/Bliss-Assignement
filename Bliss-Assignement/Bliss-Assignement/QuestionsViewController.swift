//
//  QuestionsViewController.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    private enum Segues: String {
        case questionDetail = "detailSegue"
    }
    
    private var searchButton: UIBarButtonItem!
    private var shareButton: UIBarButtonItem!
    private var searchString: String = ""
    private var currentPage: UInt = 0
    private var hasReachedLastPage: Bool = true
    private var isLoading: Bool = false
    private var questions: [Question] = []
    private var searchDelayTimer: NSTimer? = nil
    private var selectedQuestion: Question? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initLayout()
        self.updateOnSchemeLaunch()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateOnSchemeLaunch), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.networkIsReachable), name: BaseHTTPManager.networkReachable, object: nil)
    }
    
    private func initLayout() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Questions"
        self.searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(self.searchAction(_:)))
        self.navigationItem.setRightBarButtonItem(self.searchButton, animated: false)
        self.shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(self.shareAction(_:)))
        
        self.searchBar.placeholder = "Search language"
        self.searchBar.returnKeyType = .Done
        self.searchBar.enablesReturnKeyAutomatically = false
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: String(QuestionTableViewCell), bundle: nil), forCellReuseIdentifier: String(QuestionTableViewCell))
    }
    
    internal func updateOnSchemeLaunch() {
        if let filter: String = NSUserDefaults.standardUserDefaults().stringForKey("filter") {
            self.questions = []
            self.tableView.reloadData()
            self.searchBarTopConstraint.constant = -44.0
            self.searchAction(self)
            if filter == "" {
                self.searchBar.becomeFirstResponder()
                self.searchBar.text = ""
            } else {
                self.searchBar.resignFirstResponder()
                self.searchBar.text = filter
            }
            self.searchBar(self.searchBar, textDidChange: self.searchBar.text!)
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filter")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else if let id: String = NSUserDefaults.standardUserDefaults().stringForKey("id") {
            self.navigationController?.popToViewController(self, animated: false)
            self.questions = []
            self.tableView.reloadData()
            self.searchBarTopConstraint.constant = 0.0
            self.searchAction(self)
            self.searchBar.text = ""
            self.searchBar.resignFirstResponder()
            self.searchBar(self.searchBar, textDidChange: self.searchBar.text!)
            
            if let id: Int = Int(id) {
                self.getQuestion(withId: id)
            }
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("id")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            if self.questions.count == 0 {
                self.getQuestions()
            }
        }
    }
    
    internal func networkIsReachable() {
        self.hasReachedLastPage = false
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: QuestionTableViewCell = tableView.dequeueReusableCellWithIdentifier(String(QuestionTableViewCell), forIndexPath: indexPath) as! QuestionTableViewCell
        
        cell.configure(withQuestion: self.questions[indexPath.row])
        
        if !self.isLoading && !self.hasReachedLastPage && indexPath.row == self.questions.count - 5 {
            self.getQuestions()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return QuestionTableViewCell.height(forTitle: self.questions[indexPath.row].question)
    }
    
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        self.getQuestion(withId: self.questions[indexPath.row].id)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segues.questionDetail.rawValue {
            (segue.destinationViewController as! QuestionDetailsViewController).question = self.selectedQuestion
        }
    }
    
    
    // MARK: - Search bar delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText
        self.currentPage = 0
        
        if self.searchString == "" {
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.setRightBarButtonItem(self.searchButton, animated: true)
        } else {
            if self.navigationItem.rightBarButtonItems?.count == 1 {
                self.navigationItem.rightBarButtonItems = nil
                self.navigationItem.setRightBarButtonItems([self.searchButton, self.shareButton], animated: true)
            }
        }
        
        if self.searchDelayTimer != nil && (self.searchDelayTimer?.valid)! {
            self.searchDelayTimer?.invalidate()
        }
        
        self.searchDelayTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(self.getQuestions), userInfo: nil, repeats: false)
    }
    
    
    // MARK: - UIButton actions
    
    @IBAction func searchAction(sender: AnyObject) {
        if self.searchBarTopConstraint.constant == 0 {
            self.searchBar.resignFirstResponder()
            if self.navigationItem.rightBarButtonItems?.count == 2 {
                self.navigationItem.rightBarButtonItems = nil
                self.navigationItem.setRightBarButtonItem(self.searchButton, animated: true)
            }
            
            self.searchBarTopConstraint.constant = -44.0
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.searchBar.becomeFirstResponder()
            self.searchBarTopConstraint.constant = 0.0
            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        let shareView: ShareView = NSBundle.mainBundle().loadNibNamed(String(ShareView), owner: self, options: nil)?.first as! ShareView
        shareView.shareUrl = "blissrecruitment://questions?question_filter=" + self.searchString
        shareView.show()
    }
    
    
    // MARK: - Data request
    
    internal func getQuestions() {
        self.isLoading = true
        self.hasReachedLastPage = false
        self.currentPage += 1
        DataManager.sharedManager.getQuestions(forPage: self.currentPage, withFilter: self.searchString) { (questions: [Question], error: NSError?) in
            if self.currentPage == 1 {
                self.questions = []
            }
            
            if error == nil {
                self.hasReachedLastPage = UInt(questions.count) < NetworkClient.pageSize
                self.questions += questions
                self.isLoading = false
                self.tableView.reloadData()
            } else {
                self.isLoading = false
                self.hasReachedLastPage = true
                if self.currentPage == 1 {
                    ProgressHUD.showErrorHUD(UIApplication.sharedApplication().keyWindow!, text: "An error was occurred\nwhile fetching questions.")
                }
            }
        }
    }
    
    internal func getQuestion(withId id: Int) {
        ProgressHUD.showProgressHUD(UIApplication.sharedApplication().keyWindow!, text: "Loading...")
        DataManager.sharedManager.getQuestion(withId: id) { (question: Question, error: NSError?) in
            if error == nil {
                self.selectedQuestion = question
                self.performSegueWithIdentifier(Segues.questionDetail.rawValue, sender: self)
                ProgressHUD.dismissAllHuds(UIApplication.sharedApplication().keyWindow!)
            } else {
                ProgressHUD.showErrorHUD(UIApplication.sharedApplication().keyWindow!, text: "An error was occurred\nwhile fetching details.")
            }
        }
    }

}
