//
//  TopicTableViewCell.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 24/11/23.
//

import UIKit

class TopicTableViewCell: UITableViewCell {

    @IBOutlet weak var topicCardView: UIView!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var topicDifficulityLabel: UILabel!
    @IBOutlet weak var topicImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        topicCardView.layer.cornerRadius = 15
        topicCardView.layer.shadowColor = UIColor.black.cgColor
        topicCardView.layer.shadowOpacity = 0.25
        topicCardView.layer.shadowOffset.height = 4
        topicCardView.layer.shadowRadius = 7.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
