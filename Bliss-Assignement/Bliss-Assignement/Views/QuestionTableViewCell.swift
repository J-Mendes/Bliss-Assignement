//
//  QuestionTableViewCell.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit
import AlamofireImage

class QuestionTableViewCell: UITableViewCell {

    static let baseHeight: CGFloat = 32.0
    static let minHeight: CGFloat = 52.0
    
    @IBOutlet private weak var questionImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = .DisclosureIndicator
        self.questionLabel.text = ""
        self.publishDateLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.questionImageView.af_cancelImageRequest()
        self.questionImageView.backgroundColor = .lightGrayColor()
        self.questionImageView.image = nil
        self.questionLabel.text = ""
        self.publishDateLabel.text = ""
    }
    
    internal func configure(withQuestion question: Question) {
        self.questionImageView.af_setImageWithURL(NSURL(string: question.thumbUrl)!)
        self.questionLabel.text = question.question
        self.publishDateLabel.text = question.publishDate
    }
    
    class func height(forTitle title: String) -> CGFloat {
        if title != "" {
            return QuestionTableViewCell.baseHeight + (title as NSString).boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.size.width - 114.0, CGFloat.max), options: [.UsesFontLeading, .UsesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0, weight: UIFontWeightMedium)], context: nil).size.height
        }
        return QuestionTableViewCell.minHeight
    }
    
}
