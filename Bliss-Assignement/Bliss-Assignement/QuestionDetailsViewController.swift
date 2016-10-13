//
//  QuestionDetailsViewController.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit
import AlamofireImage

class QuestionDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    internal var question: Question!
    
    @IBOutlet private weak var questionImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    @IBOutlet private weak var voteLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private var shareButton: UIBarButtonItem!
    private var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initLayout()
    }
    
    private func initLayout() {
        self.title = "Detail"
        self.shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(self.shareAction(_:)))
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.setRightBarButtonItem(self.shareButton, animated: false)
        
        self.questionImageView.af_setImageWithURL(NSURL(string: self.question.imageUrl)!)
        self.questionLabel.text = self.question.question
        self.publishedDateLabel.text = self.question.publishDate
        self.voteLabel.text = "Tap on a language to vote:"
        self.tableView.tableFooterView = UIView()
    }
    
    deinit {
        self.questionImageView.af_cancelImageRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.question.choices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("choiceCell")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "choiceCell")
        }
        
        cell?.textLabel?.text = self.question.choices[indexPath.row].choice
        cell?.detailTextLabel?.text = "\(self.question.choices[indexPath.row].votes) votes"
        
        return cell!
    }
    
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
        self.question.choices[self.selectedIndex].votes! += 1
        self.tableView.reloadData()
        self.updateQuestion()
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - UIButton actions
    
    @IBAction func shareAction(sender: AnyObject) {
        //let url: String = "blissrecruitment://questions?question_id=\(self.question.id)"
        // TODO: goto share screen
    }
    
    
    // MARK: - Data request
    
    private func updateQuestion() {
        ProgressHUD.showProgressHUD(UIApplication.sharedApplication().keyWindow!, text: "Voting...")
        DataManager.sharedManager.updateQuestion(withQuestion: self.question) { (question: Question, error: NSError?) in
            if error == nil {
                ProgressHUD.dismissAllHuds(UIApplication.sharedApplication().keyWindow!)
            } else {
                self.question.choices[self.selectedIndex].votes! -= 1
                self.tableView.reloadData()
                ProgressHUD.showErrorHUD(UIApplication.sharedApplication().keyWindow!, text: "An error was occurred\nwhile voting.")
            }
        }
    }

}
