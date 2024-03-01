//
//  LessonTableViewCell.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 24/11/23.
//

import UIKit

class LessonTableViewCell: UITableViewCell {

    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var lessonTopicCountLabel: UILabel!
    @IBOutlet weak var lessonImageURL: UIImageView!
    
    @IBOutlet weak var lessonCardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lessonCardView.layer.cornerRadius = 15
        lessonCardView.layer.shadowColor = UIColor.black.cgColor
        lessonCardView.layer.shadowOpacity = 0.25
        lessonCardView.layer.shadowOffset.height = 4
        lessonCardView.layer.shadowRadius = 7.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
