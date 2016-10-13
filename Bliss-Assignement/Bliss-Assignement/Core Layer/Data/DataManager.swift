//
//  DataManager.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import Foundation

class DataManager: NSObject {

    static let sharedManager: DataManager = DataManager()
    static let domain: String = "com.jm.Bliss-Assignement.DataManager"
    
    internal func getQuestions(forPage page: UInt, withFilter filter: String, result: ([Question], NSError?) -> Void) {
        NetworkClient.sharedManager().getQuestions(page, filter: filter) { (response, error) in
            if error == nil {
                if let questionsDictionary: [[String: AnyObject]] = response as? [[String: AnyObject]] {
                    var questions: [Question] = []
                    questionsDictionary.forEach {
                        questions.append(Question(withDictionary: $0))
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        result(questions, error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        result([], NSError(domain: DataManager.domain + ".Questions", code: -2, userInfo: nil))
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    result([], error)
                })
            }
        }
    }
    
    internal func getQuestion(withId id: Int, result: (Question, NSError?) -> Void) {
        NetworkClient.sharedManager().getQuestion(id) { (response, error) in
            if error == nil {
                if let questionDictionary: [String: AnyObject] = response as? [String: AnyObject] {
                    let question: Question = Question(withDictionary: questionDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        result(question, error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        result(Question(), NSError(domain: DataManager.domain + ".Question.\(id)", code: -2, userInfo: nil))
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    result(Question(), error)
                })
            }
        }
    }
    
    internal func updateQuestion(withQuestion question: Question, result: (Question, NSError?) -> Void) {
        NetworkClient.sharedManager().updateQuestion(question.id, question: question.getDictionaryRepresentationWithUpdatedChoices()) { (response, error) in
            if error == nil {
                if let questionDictionary: [String: AnyObject] = response as? [String: AnyObject] {
                    let question: Question = Question(withDictionary: questionDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        result(question, error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        result(Question(), NSError(domain: DataManager.domain + ".Question.\(question.id)", code: -2, userInfo: nil))
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    result(Question(), error)
                })
            }
        }
    }
    
}
