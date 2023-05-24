//
//  TaskCell.swift
//  RXToDoList
//
//  Created by 심현석 on 2023/05/24.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
