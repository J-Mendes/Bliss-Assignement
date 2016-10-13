//
//  Question.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import Foundation

class Question: NSObject {

    internal var id: Int!
    internal var question: String!
    internal var imageUrl: String!
    internal var thumbUrl: String!
    internal var publishDate: String!
    internal var choices: [Choice]!
    
    private var dictionaryRepresentation: [String: AnyObject]! = [:]
    
    override init() {
        super.init()
        
        self.id = 0
        self.question = ""
        self.imageUrl = ""
        self.thumbUrl = ""
        self.publishDate = ""
        self.choices = []
    }
    
    convenience init(withDictionary dictionary: [String: AnyObject]) {
        self.init()
        
        self.dictionaryRepresentation = dictionary
        
        if let id: Int = dictionary["id"] as? Int {
            self.id = id
        }
        
        if let question: String = dictionary["question"] as? String {
            self.question = question
        }
        
        if let imageUrl: String = dictionary["image_url"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let thumbUrl: String = dictionary["thumb_url"] as? String {
            self.thumbUrl = thumbUrl
        }
        
        if let publishDate: String = dictionary["published_at"] as? String {
            self.publishDate = publishDate
        }
        
        if let choices: [[String: AnyObject]] = dictionary["choices"] as? [[String: AnyObject]] {
            choices.forEach {
                self.choices.append(Choice(withDictionary: $0))
            }
        }
    }
    
    internal func getDictionaryRepresentationWithUpdatedChoices() -> [String: AnyObject] {
        var dictionaryRepresentation: [String: AnyObject] = self.dictionaryRepresentation
        var choicesDictionary: [[String: AnyObject]] = []
        self.choices.forEach {
            choicesDictionary.append($0.toDictionaryRepresentation())
        }
        dictionaryRepresentation["choices"] = choicesDictionary
        return dictionaryRepresentation
    }
}
