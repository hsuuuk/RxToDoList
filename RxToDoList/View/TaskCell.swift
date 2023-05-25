//
//  TaskCell.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/24.
//

import UIKit
import RxCocoa
import NSObject_Rx

class TaskCell: UITableViewCell {
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var viewModel: TaskCellViewModel?
    
    var toggleCheckButton: (() -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(task: Task) {
        viewModel = TaskCellViewModel(task: task)
                
        viewModel?.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel?.timeDriver
            .drive(timeLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel?.descriptionDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel?.isCompletedDriver
            .map { $0 ? "checkmark.circle.fill" : "circle"}
            .map { UIImage(systemName: $0) }
            .drive(checkButton.rx.backgroundImage())
            .disposed(by: rx.disposeBag)
    }
    
    @IBAction func checkButtonToggle(_ sender: Any) {
        toggleCheckButton?()
    }
}

