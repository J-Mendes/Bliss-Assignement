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
    @IBOutlet private weak var tableView: UITableView!
    
    private var searchString: String = ""
    private var currentPage: UInt = 0
    private var hasReachedLastPage: Bool = true
    private var isLoading: Bool = false
    private var questions: [Question] = []
    private var searchDelayTimer: NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initLayout()
        self.getQuestions()
    }
    
    private func initLayout() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Questions"
        
        self.searchBar.placeholder = "Search language"
        self.searchBar.returnKeyType = .Done
        self.searchBar.enablesReturnKeyAutomatically = false
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: String(QuestionTableViewCell), bundle: nil), forCellReuseIdentifier: String(QuestionTableViewCell))
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
    
    func tableView(tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        self.view.endEditing(true)
        // TODO: logic to go to question detail
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Search bar delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText
        self.currentPage = 0
        
        if self.searchDelayTimer != nil && (self.searchDelayTimer?.valid)! {
            self.searchDelayTimer?.invalidate()
        }
        
        self.searchDelayTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(self.getQuestions), userInfo: nil, repeats: false)
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
                    // TODO: deal with error
                }
            }
        }
    }

}
